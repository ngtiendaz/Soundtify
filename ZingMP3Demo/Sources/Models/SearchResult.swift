//
//  SearchResult.swift
//  ZingMP3Demo
//
//  Created by Daz on 5/4/26.
//
import Foundation

struct SearchResult: Codable {
    let artists: [Artists]?
    let songs: [Songs]?
    //    let videos: [Videos]?
    let playlists: [PlayLists]?
    let counter: Counter
    let sectionId: String?
}
struct Counter: Codable{
    let song: Int?
    let artist: Int?
    let playlist: Int?
    let video: Int?
}
