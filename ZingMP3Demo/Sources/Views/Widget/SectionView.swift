//
//  Section.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import SwiftUI

struct SectionView: View{
    
    let sectionTitle: String
    let items: [PlayLists]

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
                    ForEach(items,id: \.encodeId) { item in
                        NavigationLink{
                            PlaylistDetail(playlist: item )
                        } label: {
                            VertiItem(imageUrl: item.thumbnail, title: item.title)
                        }
                    }
                }
            }
            
        }
    }
}
