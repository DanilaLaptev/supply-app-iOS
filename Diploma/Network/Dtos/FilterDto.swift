import Foundation

struct FilterDto: Codable {
    var hidden: Bool?
    var role: Bool?
    var title: String?
    var productType: [String]?
    
    var page: Int?
    var perPage: Int?
}
