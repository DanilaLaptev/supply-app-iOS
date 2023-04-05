import Foundation

struct OrganizationModel {
    let title: String
    let organiztionImageUrl: String
    let address: Address
    
    static var empty = OrganizationModel(
        title: "none",
        organiztionImageUrl: "none",
        address: Address(addressName: "none", longitude: 0, latitude: 0)
    )
}
