//
//  DBUser.swift
//  ZingMP3Demo
//
//  Created by Daz on 6/4/26.
//

import Foundation

struct DBUser: Codable, Identifiable {
    let uid: String          // ID từ Firebase Auth
    var id: String { uid }   // Giúp dùng trong List/ForEach dễ dàng
    
    let email: String?
    var displayName: String?
    var photoURL: String?    // Đây sẽ là Avatar
    
    // MARK: - Các trường bổ sung mới
    var coverURL: String?    // Ảnh bìa
    var bio: String?         // Giới thiệu bản thân
    var nickname: String?    // Tên hiển thị ngắn (ví dụ: @daz)
    
    // Thống kê (Dùng để hiển thị ở màn hình Profile)
    var followerCount: Int?
    var followingCount: Int?
    
    // MARK: - Chuyển đổi sang Dictionary để đẩy lên Firestore
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "email": email ?? "",
            "displayName": displayName ?? "",
            "photoURL": photoURL ?? "",
            "coverURL": coverURL ?? "",
            "bio": bio ?? "",
            "nickname": nickname ?? "",
            "followerCount": followerCount ?? 0,
            "followingCount": followingCount ?? 0
        ]
    }
}
