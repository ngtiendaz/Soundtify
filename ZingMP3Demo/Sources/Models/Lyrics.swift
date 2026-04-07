//
//  Lyrics.swift
//  ZingMP3Demo
//
//  Created by Daz on 5/4/26.
//

import Foundation

struct Lyrics: Codable {
    let enabledVideoBG: Bool
    let sentences: [Sentences]
    let file: String
    let defaultIBGUrls: [String]
    let bgMode: Int
    enum CodingKeys: String, CodingKey {
            case enabledVideoBG, sentences, file, defaultIBGUrls
            case bgMode = "BGMode"
        }
}

struct Sentences: Codable, Identifiable{
    var id = UUID()
    let words: [Word]?
    var fullSentence: String{
        words?.compactMap{ $0.data }.joined(separator: " ") ?? ""
    }
    var startTime: Int { words?.first?.startTime ?? 0 }
    var endTime: Int { words?.last?.endTime ?? 0 }
    enum CodingKeys: String, CodingKey {
            case words
        }
}
struct Word: Codable, Identifiable{
    var id = UUID()
    let startTime: Int // mili giây
    let endTime: Int
    let data: String?
    
    enum CodingKeys: String, CodingKey {
            case startTime, endTime, data
        }
}
