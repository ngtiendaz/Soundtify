import Foundation

struct Home : Codable
{
    let items: [HomeSections]?
    let hasMoreL : Bool?
    let total: Int?
}
