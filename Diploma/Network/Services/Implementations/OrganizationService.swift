import Foundation
import Moya

struct OrganizationService: OrganizationServiceProtocol {
    private let provider: MoyaProvider<OrganizationProvider>
    
    init(provider: MoyaProvider<OrganizationProvider> = MoyaProvider<OrganizationProvider>(plugins: [NetworkLoggerPlugin()])) {
        self.provider = provider
    }
    
    func updateOrganization(organization: OrganizationDto, completion: @escaping (Result<EmptyDto, Error>) -> ()) {
        provider.request(.updateOrganization(organization: organization)) { result in
            completion(result.handleResponse(EmptyDto.self))
        }
    }
    
    func getOrganizations(filter: FilterDto, completion: @escaping (Result<PaginatedDto<OrganizationDto>, Error>) -> ()) {
        provider.request(.getOrganizations(filter: filter)) { result in
            completion(result.handleResponse(PaginatedDto<OrganizationDto>.self))
        }
    }
    
    func getOrganization(id: Int, completion: @escaping (Result<OrganizationDto, Error>) -> ()) {
        provider.request(.getOrganization(id: id)) { result in
            completion(result.handleResponse(OrganizationDto.self))
        }
    }
}
