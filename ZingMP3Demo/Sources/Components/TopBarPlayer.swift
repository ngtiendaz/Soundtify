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
    var artistName: String?
    var body: some View {
        HStack(alignment: .top) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.down")
                    .font(.title2)
            }
            Spacer()
            if artistName == nil {
                Text(songName ?? "Unknown")
                    .font(.system(size: 14,weight: .bold))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }else{
                VStack{
                    Text(songName ?? "Unknown")
                        .font(.system(size: 14,weight: .bold))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text(artistName ?? "Unknown")
                        .font(.system(size: 13, weight: .regular))
                        .multilineTextAlignment(.center)
                }
            }
            Spacer()
            Image(systemName: "ellipsis")
                .font(.title2)
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.top,80)
    }
}

