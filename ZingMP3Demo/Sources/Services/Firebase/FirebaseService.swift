//
//  FirebaseService.swift
//  ZingMP3Demo
//
//  Created by Daz on 8/4/26.
//
import Foundation
import Combine
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseService: ObservableObject{
    
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    private var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
    
    func addToFavorites(song: Songs) async {
        guard let uid = currentUserID else{ return }
        
        let docRef = db.collection("users").document(uid)
            .collection("favorites").document(song.encodeId)
        
        let data: [String: Any] = [
            "encodeId": song.encodeId,
            "title": song.title,
            "artistsNames" : song.artistsNames ?? "Unknown",
            "thumbnaiLM": song.thumbnailM ?? "Unknown",
            "addedAt": FieldValue.serverTimestamp()
        ]
        
        do{
            try await docRef.setData(data)
        } catch{
            print("Lỗi lưu bài hát: \(error.localizedDescription)")
        }
        
    }
    
    
    func removeFromFavorites(songId : String) async{
        guard let uid = currentUserID else{ return }
        
        let docRef = db.collection("users").document(uid).collection("favorites").document(songId)
        
        do {
            try await docRef.delete()
        } catch {
            print("Lỗi xóa bài hát: \(error.localizedDescription)")
        }
    }
    
    func fetchFavorites() async -> [Songs] {
        guard let uid = currentUserID else {return [] }
        
        do {
            let snapshot = try await db.collection("users").document(uid)
                .collection("favorites").order(by: "addedAt", descending: true)
                .getDocuments()
            
            let favoriteSongs = snapshot.documents.compactMap{doc -> Songs? in
                let data = doc.data()
                
                guard let encodeId = data["encodeId"] as? String,
                      let title = data["title"] as? String else { return nil }
                
                return Songs(
                    encodeId: encodeId,
                    title: title,
                    artistsNames: data["artistsNames"] as? String ?? "",
                    artists: nil,
                    thumbnailM: data["thumbnailM"] as? String ?? "",
                    genres:  nil,
                    album:  nil,
                    like: nil,
                    listen: nil,
                    isOffical: nil
                )
            }
            return favoriteSongs
            
        } catch {
            print("Lỗi lấy danh sách: \(error.localizedDescription)")
            return []
        }
    }
    func updateSongThumbnail(songId: String, newThumbnail: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let docRef = db.collection("users").document(uid)
                       .collection("favorites").document(songId)
        
        do {
            try await docRef.updateData([
                "thumbnailM": newThumbnail
            ])
        } catch {
            print("Lỗi cập nhật link ảnh: \(error.localizedDescription)")
        }
    }
    
    func updateUserInfo(bio: String, nickname: String, displayName: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        let updatedData: [String: Any] = [
            "bio": bio,
            "nickname": nickname,
            "displayName": displayName
        ]
        
        do {
            try await userRef.updateData(updatedData)
            print("✅ Đã cập nhật profile thành công!")
        } catch {
            print("❌ Lỗi cập nhật profile: \(error.localizedDescription)")
        }
    }
    
    
}
