//
//  LinkSong.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import Foundation
struct LinkSong : Codable{
    let url128: String?
    
    enum CodingKeys: String, CodingKey {
        case url128 = "128"
    }
}
