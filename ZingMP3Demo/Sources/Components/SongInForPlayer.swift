//
//  SongInForPlayer.swift
//  ZingMP3Demo
//
//  Created by Daz on 27/3/26.
//

import SwiftUI
struct SongInForPlayer: View {
    var song : Songs
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @EnvironmentObject var router: AppRouter
    
    @Binding var showComment: Bool
    
    var body: some View {
        let isFav = playerViewModel.favoriteSongs.contains(where: { $0.encodeId == song.encodeId })
        HStack (alignment: .center){
            VStack(alignment: .leading, spacing: 4) {
                MarqueeText(text: song.title).frame(maxWidth: .infinity, alignment: .leading)
                
                if let artistlist = song.artists, !artistlist.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 0){
                            ForEach(0..<artistlist.count, id: \.self){ index in
                                let artist = artistlist[index]
                                Button{
                                    
                                    playerViewModel.isShowingPlayer = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                                    {
                                        router.push(.artist(artist))
                                    }
                                } label: {
                                    Text(artist.name ?? "Unknown Artist")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                if index < artistlist.count - 1{
                                    Text(", ").font(.headline)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                    }
                }else{
                    Text("Unknown Artist").font(.headline).foregroundColor(.white.opacity(0.7))
                }
            }
            Button(action: {
                showComment = true
            }) {
                    Image(systemName: "bubble.left.and.text.bubble.right")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.5))
                }
                .padding(.leading, 10)
            Button(action: {
                playerViewModel.toggleFavorite(song: song)
            }) {
                    Image(systemName: isFav ? "heart.fill" : "heart")
                    .font(.title)
                    .foregroundColor(isFav ? .green : .white)
                }
                .padding(.leading, 5)
        }
    }
}
