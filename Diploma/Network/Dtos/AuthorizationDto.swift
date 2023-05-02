import Foundation

struct AuthorizationDto: Codable {
    var organizationId: Int?
    var mainBranchId: Int?
    var role: OrganizationType?
    var title: String?
    var email: String?
    var password: String?
    var token: String?
}
