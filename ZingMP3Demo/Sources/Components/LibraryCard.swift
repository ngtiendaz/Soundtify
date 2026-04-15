//
//  LibraryCard.swift
//  ZingMP3Demo
//
//  Created by Daz on 9/4/26.
//

import SwiftUI

struct LibraryCard: View {
    var title: String
    var count: Int
    var icon: String
    var colors: [Color] // Đổi lại thành mảng để làm Gradient
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                
                // MARK: - Khối vuông chứa Icon với Gradient
                ZStack {
                    // Dùng LinearGradient làm nền cho khối vuông
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
                .frame(width: 55, height: 55)
                .cornerRadius(8) // Bo góc nhẹ cho hiện đại
                
                // MARK: - Phần Văn bản
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 4) {
                        // Thêm cái icon ghim hoặc playlist nhỏ cho giống hình
                        Image(systemName: "pin.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                        
                        Text("Danh sách phát • \(count) bài hát")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(.gray.opacity(0.6))
            }
            .contentShape(Rectangle()) // Giúp vùng bấm nhạy hơn
        }
    }
}
