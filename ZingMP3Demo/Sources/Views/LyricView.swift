//
//  Untitled.swift
//  ZingMP3Demo
//
//  Created by Daz on 5/4/26.
//

import SwiftUI

struct LyricView: View {
    @State private var progress: Double = 0.0
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [
                    playerViewModel.miniBarColor.lighter(by: 0.1),
                    playerViewModel.miniBarColor.lighter(by: 0.1)
                    ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ).ignoresSafeArea()
            Color.black.opacity(0.2).ignoresSafeArea()
            
            VStack{
                TopBarPlayer(songName: playerViewModel.selectedSong?.title ?? "Unknown", artistName: playerViewModel.selectedSong?.artistsNames ?? "Unknown")
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 30) {
                            if let sentences = playerViewModel.lyricData?.sentences {
                                ForEach(sentences) { sentence in
                                    Text(sentence.fullSentence)
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(playerViewModel.checkIsPlayed(sentence, in: sentences) ? .white : .black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .id(sentence.id)
                                        }
                                    }
                            }.padding(.vertical, 200)
                        }.onChange(of: playerViewModel.currentSentenceID) { oldValue, newValue in
                            if let id = newValue {
                                withAnimation(.spring()) {
                                proxy.scrollTo(id, anchor: .center)
                                    }
                                }
                            }
                        }
                
            Spacer()
            PlayBackControls(isLyricView: true, progress: $progress, viewModel: playerViewModel)
            }.padding(.horizontal, 25)
        }.navigationBarBackButtonHidden(true)
            .ignoresSafeArea(edges: .top)
    }
}
