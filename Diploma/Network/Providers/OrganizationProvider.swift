import Foundation
import Moya


enum OrganizationProvider {
    case updateOrganization
    case getOrganizations
    case getOrganization(id: Int)
}

extension OrganizationProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/organization") }
    
    var path: String {
        switch self {
        case .updateOrganization:
            return ""
        case .getOrganizations:
            return ""
        case .getOrganization(let id):
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateOrganization:
            return .get
        case .getOrganizations:
            return .get
        case .getOrganization(let id):
            return .get
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .updateOrganization:
            return .requestPlain
        case .getOrganizations:
            return .requestPlain
        case .getOrganization(let id):
            return .requestPlain
        }
    }
    
    // TODO: real samples
    var sampleData: Data {
        switch self {
        case .updateOrganization:
            return .init()
        case .getOrganizations:
            return .init()
        case .getOrganization(let id):
            return .init()
        }
    }
    var headers: [String: String]? {
        return RequestHeader.standard
    }
}
