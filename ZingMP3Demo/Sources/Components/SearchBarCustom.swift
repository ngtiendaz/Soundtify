//
//  SearchBarCustom.swift
//  ZingMP3Demo
//
//  Created by Daz on 5/4/26.
//

import SwiftUI

struct SearchBarCustom: View {
    @Binding var text: String
    // Thêm closure này để báo cho SearchView biết khi nào user nhấn nút tìm kiếm
    var onSearch: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.backgroundApp)
            
            TextField("", text: $text, prompt:
                Text("Bạn muốn nghe gì?")
                    .foregroundColor(Color.backgroundApp.opacity(0.6))
            )
            .foregroundColor(.backgroundApp)
            .autocorrectionDisabled() // Tắt tự động sửa để gõ tên bài hát tiếng Việt chuẩn hơn
            .textInputAutocapitalization(.never) // Không tự viết hoa chữ cái đầu (tùy sở thích)
            .submitLabel(.search) // Đổi nút "Return" trên bàn phím thành chữ "Search"
            .onSubmit {
                // Gọi hành động search khi nhấn Enter
                onSearch?()
            }
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.backgroundApp)
                }
            }
        }
        .padding(12)
        .background(.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
