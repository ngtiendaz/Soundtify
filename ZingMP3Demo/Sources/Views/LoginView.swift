//
//  LoginView.swift
//  ZingMP3Demo
//
//  Created by Daz on 6/4/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            // Nền tối chuẩn App nhạc
            Color.backgroundApp.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo hoặc Icon
                Image(systemName: "music.note.house.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.purple)
                    .padding(.top, 50)
                
                Text("ZingMP3 Demo")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                // Form đăng nhập bằng Email (Nếu Daz muốn dùng cả tài khoản thường)
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                    
                    SecureField("Mật khẩu", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        // Logic đăng nhập Email nếu Daz viết thêm
                    }) {
                        Text("Đăng nhập")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Text("hoặc")
                    .foregroundColor(.gray)
                
                // NÚT GOOGLE (Cái này Daz đã cấu hình xong)
                Button(action: {
                    authManager.signInWithGoogle()
                }) {
                    HStack {
                        Image(systemName: "g.circle.fill") // Có thể thay bằng logo Google xịn
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("Tiếp tục với Google")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}
