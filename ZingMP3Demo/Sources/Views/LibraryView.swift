//
//  LibraryView.swift
//  ZingMP3Demo
//
//  Created by Daz on 9/4/26.
//

import SwiftUI

struct LibraryView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @EnvironmentObject var router: AppRouter
    var body: some View {
        ZStack(alignment: .top){
            Color.backgroundApp.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10){
                TopBar(titleView: "Thư viện", typeView: "library")
            
                ScrollView{
                    VStack(alignment: .leading, spacing: 20){
                        LibraryCard(
                            title: "Bài hát ưa thích",
                            count: playerViewModel.favoriteSongs.count,
                            icon: "heart.fill",
                            colors: [Color.blue, Color.white.opacity(0.8)]
                        ) {
                            router.push(.favorites)
                        }

                        LibraryCard(
                            title: "Playlist yêu thích",
                            count: 20,
                            icon: "music.note.list",
                            colors: [Color.purple, Color.blue]
                        ) {
                            // Action khi bấm
                        }
                        LibraryCard(
                            title: "Đang theo dõi",
                            count: 20,
                            icon: "person.crop.square.filled.and.at.rectangle.fill",
                            colors: [Color.yellow, Color.orange]
                        ) {
                            // Action khi bấm
                        }
                        VStack(alignment: .leading, spacing: 15) {
                            HStack{
                                Text("Nghe gần đây").bold()
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                
                            }
                            
                            ForEach(searchViewModel.recentSongs.prefix(10), id: \.encodeId) { song in
                                Button {
                                    playerViewModel.play(song: song, from: searchViewModel.recentSongs)
                                } label: {
                                    H_SongItem( song: song )
                                }
                            }
                        }
                        
                    }.padding(.horizontal).padding(.top , 20)
                
                }
                
            }
            
        }
    }
}

