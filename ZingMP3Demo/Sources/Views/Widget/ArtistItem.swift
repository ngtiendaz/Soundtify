//
//  HorizArtist.swift
//  ZingMP3Demo
//
//  Created by Daz on 5/4/26.
//

import SwiftUI

struct ArtistItem: View {
    var id: String?
    var imageUrl: String?
    var title: String?
    var body: some View {
        VStack(alignment: .center){
            ImageCustom(imageUrl: imageUrl ?? "", width: 100, height: 100).clipShape(Circle())
                Text(title ?? "Unknown")
                              .foregroundColor(.white)
                              .font(.system(size: 14, weight: .semibold))
                              .lineLimit(1).truncationMode(.tail)
        }.frame(width: 110, height: 150)
    }
}
