//
//  Artists.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import Foundation

struct Artists: Codable,Hashable
{
    let id: String?
    let name: String?
    let thumbnail: String?
    let totalFollow: Int?
    let playlistId: String?
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: Artists, rhs: Artists) -> Bool {
            return lhs.id == rhs.id
        }
}

struct ArtistSongResponse: Codable {
    let items: [Songs] // Khớp với trường "items" trong JSON
    let total: Int?    // Khớp với trường "total" trong JSON
}
