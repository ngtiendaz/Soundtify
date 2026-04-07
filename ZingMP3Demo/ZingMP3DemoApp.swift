//
//  ZingMP3DemoApp.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import SwiftUI
import FirebaseCore
@main
struct ZingMP3DemoApp: App {
    @StateObject var authManager = AuthManager.shared
    
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
    
        WindowGroup {
//            MainView()
            ContentView().environmentObject(authManager)
        }
    }
}
