//
//  Untitled.swift
//  ZingMP3Demo
//
//  Created by Daz on 6/4/26.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Combine

class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: DBUser? // Dùng model này để quản lý dữ liệu user
    
    static let shared = AuthManager()
    private let userDefaultsKey = "user_session"
    
    init() {
        // 1. Kiểm tra Firebase
        if let firebaseUser = Auth.auth().currentUser {
            self.isLoggedIn = true
            // 2. Load dữ liệu từ bộ nhớ đệm ra trước cho nhanh
            self.loadUserFromCache()
            
            // 3. Cập nhật lại từ Firebase (phòng trường hợp user đổi ảnh/tên)
            updateUserMetadata(from: firebaseUser)
        }
    }
    
    // Lưu user vào bộ nhớ đệm
    private func saveUserToCache(_ user: DBUser) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // Đọc user từ bộ nhớ đệm
    private func loadUserFromCache() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedUser = try? JSONDecoder().decode(DBUser.self, from: data) {
            self.currentUser = savedUser
        }
    }

    // Hàm cập nhật Metadata từ Firebase User sang DBUser model
    private func updateUserMetadata(from user: User) {
        let dbUser = DBUser(
            uid: user.uid,
            email: user.email,
            photoURL: user.photoURL?.absoluteString,
            displayName: user.displayName
        )
        DispatchQueue.main.async {
            self.currentUser = dbUser
            self.saveUserToCache(dbUser)
        }
    }

    func signInWithGoogle() {
        // 1. Lấy Client ID
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // 2. Tìm rootViewController (Dòng này bị thiếu này!)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }

        // 3. Gọi sign in
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error = error {
                print("Lỗi Google Sign In: \(error.localizedDescription)")
                return
            }

            // Lấy thông tin user và idToken
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }

            // 4. Tạo chứng chỉ (Dòng này cũng bị thiếu nè!)
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                          accessToken: user.accessToken.tokenString)

            // 5. Đăng nhập vào Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Lỗi Firebase Auth: \(error.localizedDescription)")
                    return
                }
                
                if let firebaseUser = authResult?.user {
                    self?.isLoggedIn = true
                    self?.updateUserMetadata(from: firebaseUser)
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            
            // Xóa dữ liệu trong bộ nhớ đệm
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
            
            DispatchQueue.main.async {
                self.isLoggedIn = false
                self.currentUser = nil
            }
        } catch {
            print("Lỗi logout")
        }
    }
}
