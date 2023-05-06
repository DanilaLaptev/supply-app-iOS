import Foundation
import Moya


enum OrganizationProvider {
    case updateOrganization(organization: OrganizationDto)
    case getOrganizations(filter: FilterDto)
    case getOrganization(id: Int)
}

extension OrganizationProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/organization") }
    
    var path: String {
        switch self {
        case .updateOrganization, .getOrganizations:
            return "/"
        case .getOrganization(let id):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateOrganization:
            return .put
        case .getOrganizations:
            return .post
        case .getOrganization:
            return .get
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .updateOrganization(let organization):
            guard let body = CoderManager.encode(organization) else {
                return .requestPlain
            }
            
            return .requestData(body)
        case .getOrganizations(let filter):
            guard let body = CoderManager.encode(filter) else {
                return .requestPlain
            }
            
            return .requestData(body)
        case .getOrganization:
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
        case .getOrganization:
            return .init()
        }
    }
    var headers: [String: String]? {
        switch self {
        default:
            return RequestHeader.withAccessToken
        }
    }
}

extension OrganizationProvider: MoyaCacheable {
  var cachePolicy: CachePolicy {
    switch self {
    case .getOrganization, .getOrganizations:
      return .returnCacheDataElseLoad
    default:
      return .reloadIgnoringLocalAndRemoteCacheData
    }
  }
}
