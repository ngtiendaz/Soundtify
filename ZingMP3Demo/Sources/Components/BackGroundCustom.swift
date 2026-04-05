//
//  BackGroundCustom.swift
//  ZingMP3Demo
//
//  Created by Daz on 27/3/26.
//

import SwiftUI
struct BackGroundCustom: View {
    var imageUrl: String?
    var body: some View {
        GeometryReader { geometry in
                        AsyncImage(url: URL(string:imageUrl ?? "")) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill() // Quan trọng để ảnh lấp đầy khung
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .blur(radius: 20) // Độ mờ (tùy chỉnh)
                                    .clipped() // Cắt phần ảnh thừa ngoài khung
                            case .failure(_), .empty:
                                // Màu nền mặc định khi lỗi hoặc đang tải
                                Color.black
                            @unknown default:
                                Color.black
                            }
                        }
                        Color.black.opacity(0.4)
                    }
                    .ignoresSafeArea()
    }
}
