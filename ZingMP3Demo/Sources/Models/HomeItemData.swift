enum HomeItemData: Codable {
    case array([PlayLists])
    case object(NewReleaseObject) // Nếu là section new-release
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // Thử parse xem có phải là mảng không
        if let array = try? container.decode([PlayLists].self) {
            self = .array(array)
        }
        // Nếu không phải mảng, thử parse xem có phải Object không
        else if let object = try? container.decode(NewReleaseObject.self) {
            self = .object(object)
        } else {
            self = .unknown
        }
    }
}

// Model bổ trợ cho các section đặc biệt (như New Release)
struct NewReleaseObject: Codable {
    let all: [Songs]?
    let vPop: [Songs]?
    let bPop: [Songs]?
}
