import Foundation
import Moya


enum OrganizationBranchProvider {
    case createOrganizationBranch(branch: OrganizationBranchDto)
    case updateOrganizationBranch(branchId: Int, branch: OrganizationBranchDto)
    case addContactPerson(branchId: Int, contactPerson: ContactPersonDto)
    case getStorageItems(branchId: Int, filter: FilterDto)
    case addStorageItems(branchId: Int, items: [StorageItemDto])
    case updateStorageItem(branchId: Int, item: StorageItemDto)
}

extension OrganizationBranchProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/organization/branch") }
    
    var path: String {
        switch self {
        case .createOrganizationBranch:
            return "/"
        case .addContactPerson(let branchId, _):
            return "/\(branchId)/contactPerson/"
        case .updateOrganizationBranch(let branchId, _):
            return "/\(branchId)/"
        case .getStorageItems(let branchId, _):
            return "/\(branchId)/products/"
        case .addStorageItems(let branchId, _):
            return "/\(branchId)/products/"
        case .updateStorageItem(let branchId, _):
            return "/\(branchId)/products/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createOrganizationBranch, .updateOrganizationBranch, .addContactPerson, .getStorageItems:
            return .post
        case .addStorageItems:
            return .put
        case .updateStorageItem:
            return .patch
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .createOrganizationBranch(let branch):
            guard let body = CoderManager.encode(branch) else {
                return .requestPlain
            }
            
            return .requestData(body)
        case .updateOrganizationBranch(_, let branch):
            guard let body = CoderManager.encode(branch) else {
                return .requestPlain
            }
            
            return .requestData(body)
        case .addContactPerson(_, let contactPerson):
            guard let body = CoderManager.encode(contactPerson) else {
                return .requestPlain
            }
            
            return .requestData(body)
        case .getStorageItems(_, let filter):
            guard let body = CoderManager.encode(filter) else {
                return .requestPlain
            }
            
            return .requestData(body)
        case .addStorageItems(_, let storageItems):
            guard let body = CoderManager.encode(storageItems) else {
                return .requestPlain
            }
            
            return .requestData(body)
        case .updateStorageItem(_, let storageItem):
            guard let body = CoderManager.encode(storageItem) else {
                return .requestPlain
            }
            
            return .requestData(body)
        }
        
    }
    
    // TODO: real samples
    var sampleData: Data {
        switch self {
        case .createOrganizationBranch:
            return .init()
        case .updateOrganizationBranch:
            return .init()
        case .addContactPerson:
            return .init()
        case .getStorageItems:
            let product1 = ProductDto(id: 1, productType: .meat, name: "Мясо", approved: true, image: "image1")
            let storageItem1 = StorageItemDto(id: 1, price: 10.99, description: "Описание 1", quantity: 5, isHidden: false, product: product1)

            let product2 = ProductDto(id: 2, productType: .fish, name: "Рыба", approved: true, image: "image2")
            let storageItem2 = StorageItemDto(id: 2, price: 8.99, description: "Описание 2", quantity: 3, isHidden: true, product: product2)

            let items = [storageItem1, storageItem2]
            let total = 2

            let response = PaginatedDto(items: items, total: total)
            guard let body = try? JSONEncoder().encode(response) else {
                return .init()
            }
            return body
        case .addStorageItems:
            return .init()
        case .updateStorageItem:
            return .init()
        }
    }
    var headers: [String: String]? {
        return RequestHeader.withAccessToken
    }
}
