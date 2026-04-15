//
//  DetailArtists.swift
//  ZingMP3Demo
//
//  Created by Daz on 2/4/26.
//

import SwiftUI

struct ArtistView: View {
    let artist: Artists
    @Environment(\.dismiss) var dismiss
    @StateObject var artistViewModel = ArtistViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var router: AppRouter 

    var body: some View {
        ZStack(alignment: .top) {
            Color.backgroundApp.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        ImageCustom(imageUrl: artist.thumbnail, width: 400,height:.infinity)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                            .clipped()
                            .ignoresSafeArea()
                        
                        LinearGradient(
                            colors: [.clear, .backgroundApp.opacity(0.5), .backgroundApp],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .frame(height: 400)
                    VStack(alignment: .leading, spacing: 20) {
                        infoArtist

                        actionButtons

                        Text("Phổ biến")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        if artistViewModel.isLoading && artistViewModel.songs.isEmpty {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 50)
                        } else {
                            LazyVStack(spacing: 15) {
                                ForEach(artistViewModel.songs, id: \.encodeId) { song in
                                    Button {
                                        searchViewModel.saveSongToHistory(song)
                                        playerViewModel.play(song: song, from: artistViewModel.songs)
                                    } label: {
                                        H_SongItem( song: song )
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, -20)
                }
            }
            .ignoresSafeArea(edges: .top)

            backButton
        }
        .navigationBarHidden(true)
        .task(id: artist.id) {
            if let id = artist.id {
                await artistViewModel.fetchArtistSongs(artistId: artist.id ?? "")
            }
        }
    }

    private var infoArtist: some View {
        VStack(alignment: .leading,spacing: 20) {
            Text(artist.name ?? "Nghệ sĩ")
                .font(.system(size: 45, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text("\(artist.totalFollow ?? 0) người theo dõi")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
        }
    }
    private var actionButtons: some View {
        HStack(spacing: 15) {
            Button(action: {}) {
                Text("Theo dõi")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray))
            }
            Image(systemName: "ellipsis").rotationEffect(.degrees(90))
            Spacer()
            Image(systemName: "shuffle").font(.title2).foregroundColor(.green)
            Button(action: {}) {
                Image(systemName: "play.fill")
                    .font(.title2).foregroundColor(.black).padding(18)
                    .background(Color.green).clipShape(Circle())
            }
        }
        .foregroundColor(.white)
    }

    private var backButton: some View {
        HStack {
            Button(action: {
                // Đồng bộ việc back với Router
                if !router.homePath.isEmpty || !router.searchPath.isEmpty {
                    router.pop()
                } else {
                    dismiss()
                }
            }) {
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
}
