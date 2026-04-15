import SwiftUI

struct PlaylistView: View {
    var playlist: PlayLists
    @StateObject var playListViewModel = PlayListViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var searchViewModel: SearchViewModel

    var body: some View {
        let currentPlaylist = playListViewModel.playlistDetail ?? playlist
        ZStack(alignment: .top) {
            LinearGradient(
                            gradient: Gradient(colors: [playListViewModel.playlistColor.opacity(0.8), Color.backgroundApp]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    VStack {
                        ImageCustom(imageUrl: playlist.thumbnail, width: 300, height: 300)
                            .cornerRadius(4)
                            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(playlist.title ?? "Playlist Radio") // Có thể lấy từ ViewModel
                                .font(.title2).bold().foregroundColor(.white)
                            
                            HStack {
                                Image(systemName: "circle.fill").resizable().frame(width: 20, height: 20)
                                    .foregroundColor(.green)
                                Text("Dành riêng cho Nguyễn Tiến Đạt").font(.subheadline).bold().foregroundColor(.white.opacity(0.8))
                            }
                            Text(playlist.sortDescription ?? "ok").font(.caption).foregroundColor(.white.opacity(0.8)).multilineTextAlignment(.leading)
                            Text("\(playlist.listen ?? 0) lượt nghe • \(playlist.like ?? 0) lượt thích").font(.caption).foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    }
                    .padding(.top, 100) // Chừa chỗ cho nút Back
                    .padding(.horizontal)

                    // 3. THANH CÔNG CỤ (Nút Play, Tim, Download)
                    HStack(spacing: 25) {
                        Image(systemName: "plus.circle").font(.title2)
                        Image(systemName: "arrow.down.circle").font(.title2)
                        Image(systemName: "ellipsis").font(.title2)
                        Spacer()
                        Image(systemName: "shuffle").font(.title2).foregroundColor(.green)
                        
                        // NÚT PLAY TRÒN MÀU XANH
                        Button {
                            if let firstSong = playListViewModel.songs.first {
                                playerViewModel.play(song: firstSong)
                            }
                        } label: {
                            Image(systemName: "play.fill")
                                .font(.title)
                                .foregroundColor(.black)
                                .padding(18)
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .foregroundColor(.gray)

                    // 4. DANH SÁCH BÀI HÁT
                    LazyVStack(spacing: 15) {
                        if playListViewModel.isLoading {
                            ProgressView().tint(.white).padding(.top, 30)
                        } else {
                            ForEach(playListViewModel.songs, id: \.encodeId) { song in
                                Button {
                                    searchViewModel.saveSongToHistory(song)
                                    playerViewModel.play(song: song, from: playListViewModel.songs)
                                } label: {
                                    H_SongItem( song: song )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120) // Đẩy lên để không bị MiniPlayer che
                }
            }
            
            // 5. THANH TOP BAR (Nút Back cố định)
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .padding(10)
                        .background(.black.opacity(0.3))
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 50)
            .foregroundColor(.white)
        }
        .navigationBarHidden(true)
        .onAppear {
            playListViewModel.updateColor(from: playlist.thumbnail)
                }
        .task {
            await playListViewModel.fetchSongs(playlistId: playlist.universalId)
        }
    }
}
