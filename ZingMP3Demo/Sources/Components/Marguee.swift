//
//  Marguee.swift
//  ZingMP3Demo
//
//  Created by Daz on 6/4/26.
//

import SwiftUI

struct MarqueeText: View {
    let text: String
    @State private var offset: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    
    var body: some View {
        // 1. Dùng Text thật để giữ đúng diện tích layout tự nhiên
        Text(text)
            .font(.title2)
            .fontWeight(.bold)
            .lineLimit(1)
            .opacity(0) // Ẩn Text này đi, chỉ dùng để lấy khung hình
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                // 2. Dùng GeometryReader trong overlay để đo khung hình thực tế
                GeometryReader { containerGeo in
                    ZStack(alignment: .leading) {
                        Text(text)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .background(
                                GeometryReader { textGeo in
                                    Color.clear.onAppear {
                                        self.containerWidth = containerGeo.size.width
                                        self.textWidth = textGeo.size.width
                                        if textWidth > containerWidth {
                                            startAnimation()
                                        }
                                    }
                                }
                            )
                            .offset(x: offset)
                    }
                    .onAppear {
                        self.containerWidth = containerGeo.size.width
                    }
                }
            )
            .clipped() // Cắt chữ thừa
            .onChange(of: text) { _ in
                resetAndRestart()
            }
    }
    
    func startAnimation() {
        let totalOffset = textWidth - containerWidth
        guard totalOffset > 0 else { return }
        
        let duration = Double(totalOffset) * 0.03 + 1.0
        
        withAnimation(Animation.easeInOut(duration: duration).delay(2.0)) {
            offset = -totalOffset
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 3.5) {
            withAnimation(Animation.easeInOut(duration: duration)) {
                offset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 2.0) {
                if textWidth > containerWidth { startAnimation() }
            }
        }
    }
    
    func resetAndRestart() {
        offset = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if textWidth > containerWidth { startAnimation() }
        }
    }
}
