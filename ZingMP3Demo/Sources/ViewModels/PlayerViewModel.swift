//
//  PlayerViewModel.swift
//  ZingMP3Demo
//
//  Created by Daz on 26/3/26.
//

import Foundation
import Combine
import AVKit
import SwiftUI

class PlayerViewModel: ObservableObject {
    @Published var linkSong: LinkSong?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isPlaying: Bool = false
    @Published var isShowingPlayer = false
    @Published var selectedSong: Songs?
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var miniBarColor: Color = Color.backgroundApp
    @Published var songQueue: [Songs] = []
    @Published var selectedArtist: Artists? = nil
    @Published var artistToNavigate: Artists? = nil
    @Published var currentViewingArtist: Artists? = nil
    private var timeObserver: Any?
    private var player: AVPlayer?
    
    func play(song: Songs, from queue: [Songs] = []) {
            player?.pause()
            self.player = nil
            self.isPlaying = false
            self.selectedSong = song
            
            if !queue.isEmpty {
                self.songQueue = queue
            }
            
            Task {
                await loadAndPlay()
            }
        }
    func nextSong() {
            guard let currentSong = selectedSong,
                  let currentIndex = songQueue.firstIndex(where: { $0.encodeId == currentSong.encodeId }) else { return }
            
            let nextIndex = currentIndex + 1
            
            if nextIndex < songQueue.count {
                // Phát bài tiếp theo
                play(song: songQueue[nextIndex])
            } else {
                // Nếu hết danh sách, có thể quay lại bài đầu tiên (Repeat All)
                if let firstSong = songQueue.first {
                    play(song: firstSong)
                }
            }
        }
    func previousSong() {
            // Nếu nhạc đã trôi qua hơn 3 giây, bấm back sẽ quay lại đầu bài hiện tại
            if currentTime > 3 {
                seek(to: 0)
                return
            }
            
            guard let currentSong = selectedSong,
                  let currentIndex = songQueue.firstIndex(where: { $0.encodeId == currentSong.encodeId }) else { return }
            
            let prevIndex = currentIndex - 1
            
            if prevIndex >= 0 {
                play(song: songQueue[prevIndex])
            } else {
                // Nếu ở bài đầu tiên, quay lại bài cuối cùng hoặc chỉ reset bài đầu
                if let lastSong = songQueue.last {
                    play(song: lastSong)
                }
            }
        }
    
    func loadAndPlay() async {
        removeCurrentObserver()
        guard let id = selectedSong?.encodeId else { return }
        let result = await ApiSong.fetchLinkSong(id: id)
        
        await MainActor.run {
            if let urlString = result?.url128, let url = URL(string: urlString) {
                // 1. Khởi tạo player
                let playerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: playerItem)
                
                // 2. Đăng ký "tai nghe" sự kiện kết thúc bài hát
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: playerItem, // Lắng nghe đúng item hiện tại
                    queue: .main
                ) { [weak self] _ in
                    // Khi hết bài thì tự động gọi hàm nextSong đã viết
                    self?.nextSong()
                }
                
                self.player?.play()
                self.isPlaying = true
                self.getDuration()
                self.addTimeObserver()
                
                // Cập nhật màu mini bar luôn cho mượt
                if let thumb = selectedSong?.thumbnailM {
                    self.updateMiniColor(from: thumb)
                }
            }
        }
    }
    func togglePlayPause() {
        guard let player = player else { return }
                if isPlaying { player.pause() } else { player.play() }
                isPlaying.toggle()
    }
    
    func addTimeObserver() {
        // Xóa observer cũ nếu có để tránh bị chồng chéo
        removeCurrentObserver()
        // Thiết lập nghe mỗi 0.5 giây
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            // Cập nhật currentTime để Slider "tự bò"
            DispatchQueue.main.async {
                self.currentTime = time.seconds
                
                // Nếu duration chưa có (bằng 0), thử lấy lại lần nữa
                if self.duration == 0 {
                    self.duration = self.player?.currentItem?.duration.seconds ?? 0
                }
            }
        }
    }
    
    func getDuration() {
        let asset = player?.currentItem?.asset
                Task {
                    if let duration = try? await asset?.load(.duration) {
                        await MainActor.run {
                            self.duration = duration.seconds
                        }
                    }
                }
    }
    
    func seek(to value: Double) {
        let targetTime = CMTime(seconds: value, preferredTimescale: 600)
        player?.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero) { finished in
            if finished {
            }
        }
    }
    
    func formatTime(_ time: Double) -> String {
            guard !time.isNaN else { return "00:00" }
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    deinit {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
    func removeCurrentObserver() {
        if let observer = timeObserver {
            // QUAN TRỌNG: Phải dùng đúng cái player đang giữ observer đó để gỡ
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    func updateMiniColor(from urlString: String) {
        // Ép kiểu URL sang ảnh nhỏ nhất (thường là w94 thay vì w240) để xử lý cực nhanh
        let smallUrl = urlString.replacingOccurrences(of: "w240", with: "w94")
        guard let url = URL(string: smallUrl) else { return }
        
        // Tải dữ liệu ảnh nhẹ hơn giúp màu hiện lên gần như ngay lập tức
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                // Hàm averageColor sẽ chạy cực nhanh trên ảnh nhỏ
                if let extractedColor = uiImage.averageColor {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.miniBarColor = extractedColor
                        }
                    }
                }
            }
        }.resume()
    }
    func triggerNavigation(to artist: Artists) {
            // Nếu artist bấm vào KHÁC artist đang xem thì mới kích hoạt nhảy trang
            if artist.id != currentViewingArtist?.id {
                self.artistToNavigate = artist
            } else {
                // Nếu TRÙNG thì chỉ đơn giản là đóng Player thôi, không nhảy trang nữa
                self.isShowingPlayer = false
            }
        }
}

