//
//  PlayBackControls.swift
//  ZingMP3Demo
//
//  Created by Daz on 27/3/26.
//

import SwiftUI
struct PlayBackControls: View {
    var isLyricView: Bool = false
    @Binding var progress: Double
    @ObservedObject var viewModel: PlayerViewModel
    
    private var sliderValue: Binding<Double> {
        Binding(
                    get: { viewModel.currentTime },
                    set: { viewModel.seek(to: $0) }
                )
    }
    var body: some View {
        VStack{
            VStack(spacing: 8) {
                SliderCustom(viewModel: viewModel)
            
                HStack {
                    Text(viewModel.formatTime(viewModel.currentTime)).font(.caption)
                    Spacer()
                    Text(viewModel.formatTime(viewModel.duration)).font(.caption)
                }
                .foregroundColor(.white.opacity(0.6))
            }
            HStack {
               if isLyricView == true {
                    
               }else{
                   Button(action: { /* Logic shuffle sau này */ }) {
                       Image(systemName: "shuffle").font(.title3)
                   }
               }
                Spacer()
                Button(action: { viewModel.previousSong()}) {
                    Image(systemName: "backward.end.fill").font(.system(size: 35))
                }
                Spacer()
                Button(action: { viewModel.togglePlayPause()}) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 80))
                }
                Spacer()
                Button(action: { viewModel.nextSong()}) {
                    Image(systemName: "forward.end.fill").font(.system(size: 35))
                }
                Spacer()
                if isLyricView == true {
                     
                }else{
                    Button(action: { /* Logic shuffle sau này */ }) {
                         Image(systemName: "timer")
                            .font(.title3)
                    }
                }
            }
            .foregroundColor(.white)
            .padding(.vertical)
            
           if isLyricView == true {
            
           }else{
               HStack {
                   Image(systemName: "hifispeaker")
                   Spacer()
                   Image(systemName: "square.and.arrow.up")
                   Spacer()
                   Image(systemName: "list.bullet")
               }
               .foregroundColor(.white.opacity(0.7))
               .padding(.bottom,10)
               .padding(.horizontal,8)
           }
            
        }
    }
}
