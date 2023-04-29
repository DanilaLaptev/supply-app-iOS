import Foundation

struct OrganizationDto: Codable {
    var id: Int?
    var role: String?
    var title: String?
    var approved: Bool?
    var branches: [OrganizationBranchDto]
}
