import Foundation

struct OrganizationDto: Codable {
    var id: Int?
    var role: OrganizationType?
    var title: String?
    var approved: Bool?
    var branches: [OrganizationBranchDto]
    var image: String?
}
