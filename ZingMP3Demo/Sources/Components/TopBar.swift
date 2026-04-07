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
    @EnvironmentObject var authManager: AuthManager
    @State private var showingLogoutAlert = false
    
    var body: some View {
        HStack(alignment: .top){
            if let user = authManager.currentUser, let urlString = user.photoURL {
                ImageCustom(imageUrl: urlString, width: 30, height: 30)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30).foregroundColor(.white)
            }
            Text(titleView ?? "Trang chủ").font(.system(size:24,weight: .bold)).foregroundColor(.white)
            Spacer()
            Button(action: {
                showingLogoutAlert = true
            }, label:{
                Image(systemName: "gearshape.fill").resizable().scaledToFill().frame(width: 25,height: 25).tint(.white)
            }).confirmationDialog("Bạn muốn đăng xuất?", isPresented: $showingLogoutAlert, titleVisibility: .visible) {
                Button("Đăng xuất", role: .destructive) {
                    authManager.logout()
                }
                Button("Hủy", role: .cancel) {}
            }
        }.padding(.horizontal,14)
    }
}
