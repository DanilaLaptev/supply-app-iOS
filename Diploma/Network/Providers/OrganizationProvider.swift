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
            <#code#>
        case .getOrganizations:
            <#code#>
        case .getOrganization(let id):
            <#code#>
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateOrganization:
            <#code#>
        case .getOrganizations:
            <#code#>
        case .getOrganization(let id):
            <#code#>
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .updateOrganization:
            <#code#>
        case .getOrganizations:
            <#code#>
        case .getOrganization(let id):
            <#code#>
        }
    }
    
    // TODO: real samples
    var sampleData: Data {
        switch self {
        case .updateOrganization:
            <#code#>
        case .getOrganizations:
            <#code#>
        case .getOrganization(let id):
            <#code#>
        }
    }
    var headers: [String: String]? {
        return RequestHeader.standard
    }
}
