import Foundation
import Moya


enum OrganizationBranchProvider {
    case createOrganizationBranch
    case addContactPerson
    case getStorageItems
    case addStorageItems
}

extension OrganizationBranchProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/organization/branch") }
    
    var path: String {
        switch self {
        case .createOrganizationBranch:
            return ""
        case .addContactPerson:
            return ""
        case .getStorageItems:
            return ""
        case .addStorageItems:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createOrganizationBranch:
            return .get
        case .addContactPerson:
            return .get
        case .getStorageItems:
            return .get
        case .addStorageItems:
            return .get
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .createOrganizationBranch:
            return .requestPlain
        case .addContactPerson:
            return .requestPlain
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
        case .addContactPerson:
            return .init()
        case .getStorageItems:
            return .init()
        case .addStorageItems:
            return .init()
        }
    }
    var headers: [String: String]? {
        return RequestHeader.standard
    }
}
