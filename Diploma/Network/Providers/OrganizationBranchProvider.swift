import Foundation
import Moya


enum OrganizationBranchProvider {
    case createOrganizationBranch(branch: OrganizationBranchDto)
    case updateOrganizationBranch(branchId: Int, branch: OrganizationBranchDto)
    case addContactPerson(branchId: Int, contactPerson: ContactPersonDto)
    case getStorageItems(branchId: Int, filter: FilterDto)
    case addStorageItems(branchId: Int, items: [StorageItemDto])
}

extension OrganizationBranchProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/organization/branch") }
    
    var path: String {
        switch self {
        case .createOrganizationBranch:
            return "/"
        case .addContactPerson(let branchId, _):
            return "/\(branchId)/contactPerson/"
        case .getStorageItems(let branchId, _):
            return "/\(branchId)/products/"
        case .addStorageItems(let branchId, _):
            return "/\(branchId)/products/"
        case .updateOrganizationBranch(let branchId, _):
            return "/\(branchId)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createOrganizationBranch, .updateOrganizationBranch, .addContactPerson, .getStorageItems:
            return .post
        case .addStorageItems:
            return .put
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
        case .getStorageItems:
            return .requestPlain
        case .addStorageItems:
            return .requestPlain
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
            return .init()
        case .addStorageItems:
            return .init()
        }
    }
    var headers: [String: String]? {
        switch self {
        case .getStorageItems:
            return RequestHeader.standard
        default:
            return RequestHeader.withAccessToken
        }
    }
}
