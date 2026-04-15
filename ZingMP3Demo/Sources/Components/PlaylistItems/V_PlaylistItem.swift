//
//  HoriItem.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import SwiftUI
struct V_PlaylistItem: View {
   let imageUrl: String?
   let title: String?
    
    var body: some View {
        VStack(alignment: .leading){
           ImageCustom(imageUrl: imageUrl, width: 140, height: 140)
                Text(title ?? "Unknown")
                              .foregroundColor(.white)
                              .font(.system(size: 14, weight: .semibold))
                              .lineLimit(1).truncationMode(.tail)
        }.frame(width: 140, height: 160)
        }
    }
