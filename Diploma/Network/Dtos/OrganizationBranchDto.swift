import Foundation

struct OrganizationBranchDto: Codable {
    var id: Int?
    var addressName: String?
    var longitude: String?
    var latitude: Bool?
    var contactPersons: [ContactPersonDto]
}
