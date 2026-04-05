//
//  TopBarPlayer.swift
//  ZingMP3Demo
//
//  Created by Daz on 27/3/26.
//

import SwiftUI
struct TopBarPlayer: View {
    @Environment(\.dismiss) var dismiss
    var songName: String?
    var body: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.down")
                    .font(.title2)
            }
            Spacer()
            Text(songName ?? "Unknown")
                .font(.system(size: 16,weight: .bold))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Spacer()
            Image(systemName: "ellipsis")
                .font(.title2)
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.top,50)
    }
}
