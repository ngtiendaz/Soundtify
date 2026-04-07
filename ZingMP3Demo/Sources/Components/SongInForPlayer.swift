//
//  SongInForPlayer.swift
//  ZingMP3Demo
//
//  Created by Daz on 27/3/26.
//

import SwiftUI
struct SongInForPlayer: View {
    var songName: String?
    var artists: [Artists]?
    @EnvironmentObject var viewModel: PlayerViewModel
    var body: some View {
        HStack (alignment: .center){
            VStack(alignment: .leading, spacing: 4) {
                MarqueeText(text: songName ?? "Unknow Song").frame(maxWidth: .infinity, alignment: .leading)
                
                if let artistlist = artists, !artistlist.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 0){
                            ForEach(0..<artistlist.count, id: \.self){ index in
                                let artist = artistlist[index]
                                Button{
                                    viewModel.triggerNavigation(to: artist)
                                    viewModel.isShowingPlayer = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        viewModel.selectedArtist = artist
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
//            Spacer()
            Button(action: {}) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.green)
                }
                .padding(.leading, 10)
        }
    }
}
