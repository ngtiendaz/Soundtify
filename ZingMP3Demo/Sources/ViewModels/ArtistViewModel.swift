//
//  ArtistViewModel.swift
//  ZingMP3Demo
//
//  Created by Daz on 2/4/26.
//
import Foundation
import Combine

class ArtistViewModel: ObservableObject {
    @MainActor @Published var songs: [Songs] = []
    @MainActor @Published var isLoading = false
    
    private var lastFetchedArtistId: String?

    @MainActor
    func fetchArtistSongs(artistId: String) async {
        // 1. Chặn ngay lập tức nếu đang loading
        if isLoading { return }
        
        // 2. Chặn nếu ID giống hệt lần trước đã load xong
        if artistId == lastFetchedArtistId && !songs.isEmpty { return }

        isLoading = true
        defer { isLoading = false } // Đảm bảo luôn tắt loading dù thành công hay lỗi

        let fetchedSongs = await ApiArtist.getArtistSong(id: artistId)
        
        // Kiểm tra xem ID có còn khớp không (phòng trường hợp người dùng đổi Artist quá nhanh)
        self.songs = fetchedSongs
        self.lastFetchedArtistId = artistId
    }
}
