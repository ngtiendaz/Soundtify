//
//  ChatView.swift
//  ZingMP3Demo
//
//  Created by Daz on 9/4/26.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        let user = authManager.currentUser
        ZStack(alignment: .top) {
            
            Color.backgroundApp.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10){
                TopBar(titleView: user?.displayName)
            }
        }
    }
}
