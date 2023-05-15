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
    
    var sampleData: Data {
        switch self {
        case .updateOrganization:
            return .init()
        case .getOrganizations:
            let organizations = [
                OrganizationDto(id: 1, role: .worker, title: "Organization 1", approved: true, branches: [
                    OrganizationBranchDto(id: 1, addressName: "Branch 1", longitude: 30.123, latitude: 50.456, contactPeople: [
                        ContactPersonDto(fullName: "John Smith", email: "john.smith@example.com", phone: "+1 123-456-7890"),
                        ContactPersonDto(fullName: "Jane Doe", email: "jane.doe@example.com", phone: "+1 234-567-8901")
                    ])
                ], image: nil),
                OrganizationDto(id: 2, role: .supplier, title: "Organization 2", approved: true, branches: [
                    OrganizationBranchDto(id: 1, addressName: "Branch 2", longitude: 30.456, latitude: 50.789, contactPeople: [
                        ContactPersonDto(fullName: "Bob Johnson", email: "bob.johnson@example.com", phone: "+1 345-678-9012")
                    ])
                ], image: nil),
                OrganizationDto(id: 3, role: .worker, title: "Organization 3", approved: false, branches: [
                    OrganizationBranchDto(id: 1, addressName: "Branch 3", longitude: 30.789, latitude: 50.123, contactPeople: [
                        ContactPersonDto(fullName: "Alice Lee", email: "alice.lee@example.com", phone: "+1 456-789-0123")
                    ])
                ], image: nil),
                OrganizationDto(id: 4, role: .supplier, title: "Organization 4", approved: true, branches: [
                    OrganizationBranchDto(id: 1, addressName: "Branch 4", longitude: 30.123, latitude: 50.456, contactPeople: [
                        ContactPersonDto(fullName: "Tom Wilson", email: "tom.wilson@example.com", phone: "+1 567-890-1234"),
                        ContactPersonDto(fullName: "Kate Brown", email: "kate.brown@example.com", phone: "+1 678-901-2345")
                    ])
                ], image: nil),
                OrganizationDto(id: 5, role: .worker, title: "Organization 5", approved: true, branches: [
                    OrganizationBranchDto(id: 1, addressName: "Branch 5", longitude: 30.456, latitude: 50.789, contactPeople: [
                        ContactPersonDto(fullName: "David Taylor", email: "david.taylor@example.com", phone: "+1 789-012-3456")
                    ])
                ], image: nil)
            ]
            let response = PaginatedDto(items: organizations, total: organizations.count)
            guard let body = try? JSONEncoder().encode(response) else {
                return .init()
            }
            return body
        case .getOrganization:
            let response = OrganizationDto(id: 4, role: .supplier, title: "Organization 4", approved: true, branches: [
                OrganizationBranchDto(id: 1, addressName: "Branch 4", longitude: 30.123, latitude: 50.456, contactPeople: [
                    ContactPersonDto(fullName: "Tom Wilson", email: "tom.wilson@example.com", phone: "+1 567-890-1234"),
                    ContactPersonDto(fullName: "Kate Brown", email: "kate.brown@example.com", phone: "+1 678-901-2345")
                ])
            ], image: nil)
            
            guard let body = try? JSONEncoder().encode(response) else {
                return .init()
            }
            return body
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
