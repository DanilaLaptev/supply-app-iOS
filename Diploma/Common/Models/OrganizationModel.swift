import Foundation

struct OrganizationModel: Identifiable {
    var id: Int? = UUID().hashValue
    var title: String?
    var image: String?
    var organizationType: OrganizationType?
    var approved: Bool?
    
    var branches: [OrganizationBranchModel]
    
    var mainBranch: OrganizationBranchModel? {
        branches.last
    }
    
    
    var mainContact: ContactPersonModel? {
        mainBranch?.contacts.last
    }
    
    static func from(_ dto: OrganizationDto) -> OrganizationModel {
        OrganizationModel(
            id: dto.id,
            title: dto.title,
            image: dto.image,
            organizationType: dto.role,
            approved: dto.approved,
            branches: dto.branches.map { OrganizationBranchModel.from($0) }
        )
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
