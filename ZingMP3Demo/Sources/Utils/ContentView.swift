//
//  ContentView.swift
//  ZingMP3Demo
//
//  Created by Daz on 6/4/26.
//
import SwiftUI


struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Group {
            if authManager.isLoggedIn {
                // Đổi tên thành cái View màn hình chính của Daz (ví dụ HomeView hoặc MainTabBar)
                MainView()
                    .transition(.opacity)
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: authManager.isLoggedIn)
    }
}
