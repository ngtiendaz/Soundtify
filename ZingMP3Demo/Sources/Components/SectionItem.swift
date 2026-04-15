//
//  Section.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import SwiftUI

struct SectionItem: View{
    
    let sectionTitle: String
    let items: [PlayLists]
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack {
            HStack {
                Text(sectionTitle)
                    .font(.system(size: 24, weight: .bold)).foregroundColor(.white)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false)
            {
                LazyHStack(spacing: 12){
                    ForEach(items,id: \.universalId) { item in
                        Button{
                            router.push(.playlist(item))
                        } label: {
                            V_PlaylistItem(imageUrl: item.thumbnail, title: item.title)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
        }
    }
}
