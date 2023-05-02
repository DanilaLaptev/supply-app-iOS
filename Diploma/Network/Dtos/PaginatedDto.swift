import Foundation

struct PaginatedDto<Item: Codable>: Codable {
    let items: [Item]
    let total: Int?
}
