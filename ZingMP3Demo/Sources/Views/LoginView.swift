//
//  LoginView.swift
//  ZingMP3Demo
//
//  Created by Daz on 6/4/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authManager = AuthManager.shared
    
    var body: some View {
        ZStack {
            // 1. Nền đen sâu (chuẩn Spotify)
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                // 2. Logo biểu tượng
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("Hàng triệu bài hát.\nMiễn phí trên Soundtify.")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // 3. Khu vực các nút bấm (Capsule Style)
                VStack(spacing: 12) {
                    
                    // Nút Đăng ký miễn phí (Dành cho Email)
                    Button(action: {
                        // Điều hướng sang màn hình đăng ký/đăng nhập email
                    }) {
                        Text("Đăng ký miễn phí")
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.green) // Có thể dùng màu xanh lá nếu muốn giống hệt
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    
                    // Nút Google - Bo tròn Capsule
                    Button(action: {
                        authManager.signInWithGoogle()
                    }) {
                        HStack {
                            Image(systemName: "g.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Tiếp tục bằng Google")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .overlay(
                            Capsule().stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    
                    // Nút Đăng nhập Apple (Nếu có)
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "applelogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                            Text("Tiếp tục bằng Apple")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .overlay(
                            Capsule().stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 30)
                
                // 4. Dòng chuyển hướng Đăng nhập nhỏ
                Button(action: {}) {
                    Text("Đăng nhập")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.top, 10)
                
                Spacer().frame(height: 30)
            }
        }
    }
}
