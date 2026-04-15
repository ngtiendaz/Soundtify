//
//  FavoriteView.swift
//  ZingMP3Demo
//
//  Created by Daz on 9/4/26.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
   
    let favColor = Color(red: 0.2, green: 0.1, blue: 0.5)

    var body: some View {
        ZStack(alignment: .top) {
            // 1. BACKGROUND GRADIENT
            LinearGradient(
                gradient: Gradient(colors: [favColor.opacity(0.8), Color.backgroundApp]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // 2. HEADER: Ảnh đại diện playlist
                    VStack {
                        // Card icon Trái tim lớn
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            Image(systemName: "heart.fill")
                                .font(.system(size: 100))
                                .foregroundColor(.white)
                        }
                        .frame(width: 250, height: 250)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                        
                        // Thông tin Playlist
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bài hát ưa thích")
                                .font(.largeTitle).bold().foregroundColor(.white)
                            
                            HStack {
                                if let user = authManager.currentUser, let urlString = user.photoURL {
                                    ImageCustom(imageUrl: urlString, width: 20, height: 20)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundColor(.green)
                                }
                                Text("Nguyễn Tiến Đạt").font(.subheadline).bold().foregroundColor(.white)
                            }
                            
                            Text("\(playerViewModel.favoriteSongs.count) bài hát")
                                .font(.caption).foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    }
                    .padding(.top, 100)
                    .padding(.horizontal)

                    // 3. THANH CÔNG CỤ (Play, Shuffle...)
                    HStack(spacing: 25) {
                        Image(systemName: "plus.circle").font(.title2)
                        Image(systemName: "arrow.down.circle").font(.title2)
                        Image(systemName: "ellipsis").font(.title2)
                        Spacer()
                        Image(systemName: "shuffle").font(.title2).foregroundColor(.green)
                        
                        // Nút Play All
                        Button {
                            if let firstSong = playerViewModel.favoriteSongs.first {
                                playerViewModel.play(song: firstSong, from: playerViewModel.favoriteSongs)
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

                    // 4. DANH SÁCH BÀI HÁT TỪ FIREBASE
                    LazyVStack(spacing: 15) {
                        if playerViewModel.favoriteSongs.isEmpty {
                            VStack(spacing: 20) {
                                Text("Chưa có bài hát nào")
                                    .foregroundColor(.gray)
                                    .padding(.top, 50)
                            }
                        } else {
                            ForEach(playerViewModel.favoriteSongs, id: \.encodeId) { song in
                                Button {
                                    searchViewModel.saveSongToHistory(song)
                                    playerViewModel.play(song: song, from: playerViewModel.favoriteSongs)
                                } label: {
                                    H_SongItem( song: song )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
            
            // 5. TOP BAR (Nút Back)
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
    }
}
