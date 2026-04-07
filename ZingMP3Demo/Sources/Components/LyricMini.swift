//
//  LyricMini.swift
//  ZingMP3Demo
//
//  Created by Daz on 5/4/26.
//

import SwiftUI

struct LyricMini: View {
    @EnvironmentObject var viewModel: PlayerViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            LinearGradient(
                            gradient: Gradient(colors: [
                                viewModel.miniBarColor.lighter(by: 0.1), // Màu trích xuất từ ảnh
                                viewModel.miniBarColor.lighter(by: 0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
                        // Một lớp phủ mờ tối nhẹ để chữ trắng luôn nổi bật
                        Color.black.opacity(0.2).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Bản xem trước lời bài hát")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
                
                VStack(alignment: .leading) {
                    if let sentences = viewModel.lyricData?.sentences, !sentences.isEmpty {
                        let currenAndNext = viewModel.getCurrentAndNextSentences(from: sentences)
                
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(currenAndNext) { sentence in
                                Text(sentence.fullSentence)
                                    .padding(.bottom,5)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(viewModel.checkIsPlayed(sentence, in: sentences) ? .white : .black)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(2)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .move(edge: .top).combined(with: .opacity)
                                    ))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        // Hiệu ứng dịch chuyển mượt mà
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.currentSentenceID)
                    } else {
                        Text("Đang tải lời bài hát...").foregroundColor(.gray)
                    }
                }
                .frame(height: 250, alignment: .topLeading)
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black, location: 0.05),
                            .init(color: .black, location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipped()
                Spacer(minLength: 10)
                NavigationLink {
                    LyricView(songName: viewModel.selectedSong?.title ?? "", artistName: viewModel.selectedSong?.artistsNames ?? "")
                }label: {
                        Text("Hiện lời bài hát")
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .bold))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(20)
                }
            }
            .padding(16)
        }
        .frame(width: 380, height: 380)
        .cornerRadius(10)
        
    }
}
