//
//  Albums.swift
//  ZingMP3Demo
//
//  Created by Daz on 25/3/26.
//

import Foundation
struct Albums: Codable {
    let encodeId: String?
    let title: String?
    let thumbnail: String?
    let releaseDate: String?
    let genreIds: [String]?
    let artists: [Artists]?
}
