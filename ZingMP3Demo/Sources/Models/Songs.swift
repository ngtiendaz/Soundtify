import Foundation

struct Songs: Codable, Identifiable, Equatable{
    let encodeId: String
    let title: String
    let artistsNames: String?
    let artists: [Artists]?
    let thumbnailM: String?
    let genres: [Genres]?
    let album: Albums?
    let like: Int?
    let listen: Int?
    let isOffical: Bool?
  
    enum CodingKeys: String, CodingKey {
        case encodeId, title, artistsNames, artists, thumbnailM, genres, album, like, listen, isOffical
    }
    
    static func == (lhs: Songs, rhs: Songs) -> Bool {
            return lhs.encodeId == rhs.encodeId
        }
    var id: String { encodeId }
}
