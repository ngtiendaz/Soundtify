import Foundation

struct PlayLists: Codable , Hashable{
    let encodeId: String?
    let id: String?
    let title: String?
    let thumbnail: String?
    let releaseDate: String?
    let sortDescription: String?
    let genreIds: [String]?
    let artists: [Artists]?
    let artistsNames: String?
    let textType: String?
    let description: String?
    let sectionId: String?
    let genres: [Genres]?
    let song: [Songs] // Mảng bài hát sau khi đã "phẳng hóa"
    let like: Int?
    let listen: Int?
    
    var universalId: String {
        return encodeId ?? id ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case encodeId, id, title, thumbnail, releaseDate, sortDescription
        case genreIds, artists, artistsNames, textType, description
        case sectionId, genres, song, like, listen
    }

    // Key để mở lớp "items" bên trong "song"
    enum SongKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 1. Giải mã các trường cơ bản
        encodeId = try container.decodeIfPresent(String.self, forKey: .encodeId)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        sortDescription = try container.decodeIfPresent(String.self, forKey: .sortDescription)
        genreIds = try container.decodeIfPresent([String].self, forKey: .genreIds)
        artists = try container.decodeIfPresent([Artists].self, forKey: .artists)
        artistsNames = try container.decodeIfPresent(String.self, forKey: .artistsNames)
        textType = try container.decodeIfPresent(String.self, forKey: .textType)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        sectionId = try container.decodeIfPresent(String.self, forKey: .sectionId)
        genres = try container.decodeIfPresent([Genres].self, forKey: .genres)
        like = try container.decodeIfPresent(Int.self, forKey: .like)
        listen = try container.decodeIfPresent(Int.self, forKey: .listen)

        // 2. Logic xử lý "song": { "items": [...] }
        // Dùng do-catch để debug chính xác lỗi decode của mảng Songs
        if container.contains(.song) {
            do {
                // Thử mở ngăn "song"
                let songContainer = try container.nestedContainer(keyedBy: SongKeys.self, forKey: .song)
                // Thử giải mã mảng "items"
                self.song = try songContainer.decode([Songs].self, forKey: .items)
            } catch {
                // Nếu lỗi (có thể do 'song' là mảng rỗng [] thay vì object {}), gán mảng rỗng
                print("⚠️ Lưu ý: Không tìm thấy mảng 'items' hoặc lỗi cấu trúc Songs: \(error)")
                self.song = []
            }
        } else {
            self.song = []
        }
    }
    static func == (lhs: PlayLists, rhs: PlayLists) -> Bool {
            return lhs.universalId == rhs.universalId
        }

        // 2. Thêm hàm Hashable (Nếu Swift vẫn báo lỗi Hashable)
        func hash(into hasher: inout Hasher) {
            hasher.combine(universalId)
        }
}
