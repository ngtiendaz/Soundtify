//
//  ProfileView.swift
//  ZingMP3Demo
//
//  Created by Daz on 9/4/26.
//

import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        // Lấy thông tin user hiện tại
        let user = authManager.currentUser
        
        ZStack(alignment: .top) {
            Color.backgroundApp.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // MARK: - 1. ẢNH BÌA (Cover Image)
                    ZStack(alignment: .bottomTrailing) {
                        if let cover = user?.coverURL, !cover.isEmpty {
                            ImageCustom(imageUrl: cover, width: UIScreen.main.bounds.width, height: 200)
                        } else {
                            // Ảnh bìa mặc định nếu chưa có
                            LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .top, endPoint: .bottom)
                                .frame(height: 200)
                        }
                        
                        // Nút đổi ảnh bìa nhỏ ở góc
                        Image(systemName: "camera.fill")
                            .padding(8)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    
                    // MARK: - 2. AVATAR & INFO (Phần đè lên ảnh bìa)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .bottom) {
                            // Avatar
                            ZStack(alignment: .bottomTrailing) {
                                ImageCustom(imageUrl: user?.photoURL ?? "", width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.backgroundApp, lineWidth: 4))
                                
                                Image(systemName: "camera.fill")
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            }
                            .offset(y: -40) // Đẩy avatar lên trên ảnh bìa
                            
                            Spacer()
                            
                            // Nút Edit Profile giống trong ảnh
                            Button {
                                // Action edit
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .offset(y: -10)
                        }
                        
                        // Tên và Bio
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user?.displayName ?? "Người dùng Zing")
                                .font(.title.bold())
                                .foregroundColor(.white)
                            
                            HStack {
                                Text("\(user?.followerCount ?? 0) người theo dõi")
                                Text("•")
                                Text("\(user?.followingCount ?? 0) đang theo dõi")
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                        .padding(.top, -30)
                        
                        // MARK: - 3. THÔNG TIN CHI TIẾT (Bio, Location...)
                        VStack(alignment: .leading, spacing: 15) {
                            Divider().background(Color.gray.opacity(0.3))
                            
                            DetailRow(icon: "quote.opening", text: user?.bio ?? "Chưa có tiểu sử")
                        }
                        .padding(.top, 10)

                    }
                    .padding(.horizontal)
                }
            }.ignoresSafeArea(edges: .top)
            
            // TOP BAR cố định ở trên
            TopBar(isProfile: true)
                .background(Color.clear)
        }
    }
}

// Component phụ cho các dòng chi tiết
struct DetailRow: View {
    var icon: String
    var text: String
    var isLink: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            Text(text)
                .foregroundColor(isLink ? .blue : .white)
                .font(.body)
            Spacer()
        }
    }
}
