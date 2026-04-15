//
//  Comment.swift
//  ZingMP3Demo
//
//  Created by Daz on 9/4/26.
//

import SwiftUI

struct CommentSheetView: View {
  
   
    var song: Songs
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Header của Sheet
                HStack {
                    Text("Bình luận")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        dismiss() // Đóng sheet
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                }
                .padding()
                
                Divider().background(Color.gray.opacity(0.3))
                
                // MARK: - Nội dung bình luận (Giả lập)
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(0..<10, id: \.self) { _ in
                            HStack(alignment: .center, spacing: 12) {
                                if let user = authManager.currentUser, let urlString = user.photoURL {
                                    ImageCustom(imageUrl: urlString, width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Daz").bold()
                                        .foregroundColor(.white)
                                    Text("Được đấy chứ")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                
                Spacer()
                
                // MARK: - Ô nhập bình luận (Giả lập)
                HStack {
                    TextField("Viết bình luận...", text: .constant(""))
                        .padding(12)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    
                    Button() {
                        // Action gửi
                    } label: {
                        Image(systemName:"paperplane").foregroundColor(.green)
                    }.frame(width: 40,height: 40)
                    .padding(.trailing, 10)
                }
                .padding()
            }
            .background(Color.backgroundApp)
            .navigationBarHidden(true)
        }
    }
}
