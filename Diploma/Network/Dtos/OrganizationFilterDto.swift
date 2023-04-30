import Foundation

struct OrganizationFilterDto: Codable {
    var hidden: Bool?
    var role: Bool?
    var title: Bool?
    var productType: [String]
    
    var page: Int?
    var perPage: Int?
}
