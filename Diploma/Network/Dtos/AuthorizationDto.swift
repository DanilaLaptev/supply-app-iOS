import Foundation

struct AuthorizationDto: Codable {
    var id: Int?
    var role: String?
    var title: String?
    var email: String?
    var password: String?
    var token: String?
}
