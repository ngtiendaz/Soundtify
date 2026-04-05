import Foundation

struct Songs: Codable {
    let encodeId: String
    let title: String
    let artistsNames: String?
    let artists: [Artists]? // Sửa từ artist thành artists và để Optional
    let thumbnailM: String?
    let genres: [Genres]?
    
    // QUAN TRỌNG: Album là Object đơn lẻ, không phải Mảng
    let album: Albums?
    
    let like: Int?
    let listen: Int?
    let isOffical: Bool?

    enum CodingKeys: String, CodingKey {
        case encodeId, title, artistsNames, artists, thumbnailM, genres, album, like, listen, isOffical
    }
}
