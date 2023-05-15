import Foundation

struct OrganizationBranchDto: Codable {
    var id: Int?
    var addressName: String?
    var longitude: Double?
    var latitude: Double?
    var contactPeople: [ContactPersonDto]
}
