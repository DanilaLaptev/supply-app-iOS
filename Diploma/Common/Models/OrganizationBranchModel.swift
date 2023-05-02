import Foundation

struct OrganizationBranchModel: Identifiable {
    var id: Int? = UUID().hashValue
    let address: Address?
    
    let contacts: [ContactPersonModel]
    
    static func from(_ dto: OrganizationBranchDto) -> OrganizationBranchModel {
        let contacts = dto.contactPersons.map { ContactPersonModel.from($0) }
        return OrganizationBranchModel(
            id: dto.id,
            address: Address(
                addressName: dto.addressName,
                longitude: dto.longitude,
                latitude: dto.latitude
            ),
            contacts: contacts
        )
    }
    
    static var empty = OrganizationBranchModel(
        id: UUID().hashValue,
        address: nil,
        contacts: []
    )
    
}
