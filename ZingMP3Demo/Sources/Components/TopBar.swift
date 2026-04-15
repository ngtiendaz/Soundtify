//
//  HomeBar.swift
//  ZingMP3Demo
//
//  Created by Daz on 27/3/26.
//
import SwiftUI

struct TopBar: View {
    var titleView: String?
    var imageUser: String?
    var typeView: String?
    var isProfile: Bool = false
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    var onEditTap: (() -> Void)? = nil
    
    @EnvironmentObject var authManager: AuthManager
    @State private var showingLogoutAlert = false
    
    var body: some View {
        HStack(alignment: .center) { 
            
            
            if !isProfile {
                HStack(spacing: 10) {
                    if let user = authManager.currentUser, let urlString = user.photoURL {
                        ImageCustom(imageUrl: urlString, width: 30, height: 30)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    
                    Text(titleView ?? "Trang chủ")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            } else {
                Spacer().frame(width: 30)
            }
            
            Spacer()
            
          
            if isProfile {
            
                Button {
                    onEditTap?()
                } label: {
                    Image(systemName: "pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
            } else {
                Button(action: {
                    showingLogoutAlert = true
                }, label: {
                    Image(systemName: "bell.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                })
                .confirmationDialog("Bạn muốn đăng xuất?", isPresented: $showingLogoutAlert, titleVisibility: .visible) {
                    Button("Đăng xuất", role: .destructive) {
                        authManager.logout()
                        playerViewModel.stopMusic()
                        
                    }
                    Button("Hủy", role: .cancel) {}
                }
            }
        }
        .frame(height: 44) 
        .padding(.horizontal, 14)
        .background(Color.clear)
    }
}
