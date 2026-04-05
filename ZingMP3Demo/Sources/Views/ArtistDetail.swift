//
//  DetailArtists.swift
//  ZingMP3Demo
//
//  Created by Daz on 2/4/26.
//

import SwiftUI

struct ArtistDetail: View {
    var artist: Artists
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ArtistViewModel()
    @EnvironmentObject var playerManager: PlayerViewModel

    var body: some View {
        ZStack(alignment: .top) {
            // Nền đen cố định toàn màn hình
            Color.backgroundApp.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // 1. PHẦN HEADER (ẢNH & GRADIENT)
                    ZStack(alignment: .bottom) {
                        ImageCustom(imageUrl: artist.thumbnail, width: 400,height:.infinity)
                                          .aspectRatio(contentMode: .fill)
                                          .frame(width: UIScreen.main.bounds.width, height: 400)
                                          .clipped()
                                          .ignoresSafeArea()

                        // Gradient phủ lên chân ảnh để chuyển màu mượt sang nền đen
                        LinearGradient(
                            colors: [.clear, .backgroundApp.opacity(0.1), .backgroundApp],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .frame(height: 400)

                    // 2. PHẦN NỘI DUNG (CHỮ & LIST)
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text(artist.name ?? "Artist Name")
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("\(artist.totalFollow ?? 0) người theo dõi")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        // Action Bar
                        HStack(spacing: 15) {
                            Button(action: {}) {
                                Text("Theo dõi")
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray))
                            }
                            
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                            
                            Spacer()
                            
                            Image(systemName: "shuffle")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            Button(action: {}) {
                                Image(systemName: "play.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .padding(18)
                                    .background(Color.green)
                                    .clipShape(Circle())
                            }
                        }
                        .foregroundColor(.white)
                        
                        Text("Phổ biến")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        LazyVStack(spacing: 15) {
                            if viewModel.isLoading {
                                ProgressView().tint(.white).padding(.top, 30)
                            } else {
                                ForEach(viewModel.songs, id: \.encodeId) { song in
                                    Button {
                                        playerManager.play(song: song, from: viewModel.songs)
                                    } label: {
                                        HorizItem(
                                            encodeId: song.encodeId,
                                            imageUrl: song.thumbnailM,
                                            songName: song.title,
                                            artistName: song.artistsNames
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.trailing)
                      
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, -20) // Đẩy nội dung đè nhẹ lên gradient cho đẹp
                }
            }
            .ignoresSafeArea(edges: .top)

            // 3. NÚT BACK CỐ ĐỊNH (Floating)
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .padding(10)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 50)
        }
        .navigationBarHidden(true)
        .task {
            // Dùng id từ object artist truyền sang
            if let id = artist.id {
                await viewModel.fetchArtistSongs(artistId: id)
            }
        }
    }
    
}
