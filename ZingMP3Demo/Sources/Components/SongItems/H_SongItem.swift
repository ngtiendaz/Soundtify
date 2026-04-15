//
//  HorizItem.swift
//  ZingMP3Demo
//
//  Created by Daz on 26/3/26.
//

import SwiftUI

struct H_SongItem: View {
    var song: Songs
    
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    
    var body: some View {
        let isSelected = playerViewModel.selectedSong?.encodeId == song.encodeId
            HStack{
                ImageCustom(imageUrl: song.thumbnailM, width: 55, height: 55){
                    // Trường hợp 1: Link không nil nhưng load thất bại
                    print("⚠️ Ảnh bài \(song.title) load lỗi, đang tìm link mới...")
                    Task {
                        await playerViewModel.refreshSongMetadata(songId: song.encodeId)
                    }
                }
                
                VStack(alignment: .leading){
                    HStack(spacing: 6)
                    {
                        if isSelected {
                            Image(systemName: "waveform")
                                .symbolEffect(.bounce, options: .repeating, value: playerViewModel.isPlaying)
                                .foregroundColor(.green)
                        }
                        Text(song.title )
                            .foregroundColor(isSelected ? .green : .white.opacity(0.8))
                            .font(.system(size: 18, weight: .semibold))
                            .lineLimit(1)
                    }
                    Text(song.artistsNames ?? "Unknown")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 16, weight: .regular))
                        .lineLimit(1).truncationMode(.tail)
                }
                Spacer()
                Button{
                    
                } label: {
                    Image(systemName:"ellipsis").resizable().scaledToFit().frame(width: 20,height: 20).tint(.white.opacity(0.5))
                }
            }.background(Color.clear)
            .animation(.easeInOut, value: isSelected)
            .onAppear {
                // Nếu link ảnh bị mất (nil hoặc rỗng) hoặc là placeholder "Unknown"
                if song.thumbnailM == nil || song.thumbnailM == "" || song.thumbnailM == "Unknown" {
                    print("🔄 Link ảnh bài \(song.title) bị lỗi, đang lấy link mới...")
                    
                    Task {
                        await playerViewModel.refreshSongMetadata(songId: song.encodeId)
                    }
                }
            }
    }
}
