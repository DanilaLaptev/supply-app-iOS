import Foundation

struct OrganizationModel: Identifiable {
    var id: Int? = UUID().hashValue
    var title: String?
    var image: String?
    var organizationType: OrganizationType?
    var approved: Bool?
    
    var branches: [OrganizationBranchModel]
    
    static func from(_ dto: OrganizationDto) -> OrganizationModel {
        OrganizationModel(
            id: dto.id,
            title: dto.title,
            image: dto.image,
            organizationType: dto.role,
            approved: dto.approved,
            branches: [])
    }
    
    static var empty = OrganizationModel(
        id: UUID().hashValue,
        title: "None",
        image: "image url",
        organizationType: .worker,
        approved: true,
        branches: [
            
        ]
    )
}
