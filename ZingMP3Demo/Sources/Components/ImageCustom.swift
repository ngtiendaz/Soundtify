//
//  ImageCustom.swift
//  ZingMP3Demo
//
//  Created by Daz on 27/3/26.
//

import SwiftUI

struct ImageCustom: View {
    var imageUrl: String?
    var width: CGFloat = 100
    var height: CGFloat = 100
    
    var body: some View {
        AsyncImage(url: URL( string: imageUrl ?? "")){ phase in
            switch phase{
            case .empty:
                ProgressView().frame(width: width, height: height)
            case .success(let image):
                image.resizable()
                    .scaledToFill()
                    .frame(width: height , height: height)
                    .clipped()
                    .cornerRadius(6)
            case .failure:
                Image(systemName:"photo").resizable()
                    .scaledToFit().frame(width: height, height: height)
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
}
