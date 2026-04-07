//
//  HorizItem.swift
//  ZingMP3Demo
//
//  Created by Daz on 26/3/26.
//

import SwiftUI

struct HorizSongItem: View {
    var encodeId: String
    var imageUrl: String?
    var songName: String?
    var artistName: String?
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    
    var body: some View {
        let isSelected = playerViewModel.selectedSong?.encodeId == encodeId
            HStack{
               ImageCustom(imageUrl: imageUrl, width: 55, height: 55)
                VStack(alignment: .leading){
                    HStack(spacing: 6)
                    {
                        if isSelected {
                            Image(systemName: "waveform")
                                .symbolEffect(.bounce, options: .repeating, value: playerViewModel.isPlaying)
                                .foregroundColor(.green)
                        }
                        Text(songName ?? "Unknown")
                            .foregroundColor(isSelected ? .green : .white.opacity(0.8))
                            .font(.system(size: 18, weight: .semibold))
                            .lineLimit(1)
                    }
                    Text(artistName ?? "Unknown")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 16, weight: .regular))
                        .lineLimit(1).truncationMode(.tail)
                }
                Spacer()
                Button{
                    
                } label: {
                    Image(systemName:"ellipsis").resizable().scaledToFit().frame(width: 25,height: 25).tint(.white.opacity(0.5))
                }
            }.background(Color.clear)
            .animation(.easeInOut, value: isSelected)
    }
}
