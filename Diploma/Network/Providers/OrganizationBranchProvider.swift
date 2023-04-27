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
            <#code#>
        case .addContactPerson:
            <#code#>
        case .getStorageItems:
            <#code#>
        case .addStorageItems:
            <#code#>
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createOrganizationBranch:
            <#code#>
        case .addContactPerson:
            <#code#>
        case .getStorageItems:
            <#code#>
        case .addStorageItems:
            <#code#>
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .createOrganizationBranch:
            <#code#>
        case .addContactPerson:
            <#code#>
        case .getStorageItems:
            <#code#>
        case .addStorageItems:
            <#code#>
        }
    }
    
    // TODO: real samples
    var sampleData: Data {
        switch self {
        case .createOrganizationBranch:
            <#code#>
        case .addContactPerson:
            <#code#>
        case .getStorageItems:
            <#code#>
        case .addStorageItems:
            <#code#>
        }
    }
    var headers: [String: String]? {
        return RequestHeader.standard
    }
}
