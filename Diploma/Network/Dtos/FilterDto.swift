import Foundation

struct FilterDto: Codable {
    var hidden: Bool?
    var role: OrganizationType?
    var title: String?
    var productType: [ProductType]?
    
    var page: Int?
    var perPage: Int?
}
