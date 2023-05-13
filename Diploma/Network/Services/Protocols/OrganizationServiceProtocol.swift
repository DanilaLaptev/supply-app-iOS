import Foundation

protocol OrganizationServiceProtocol {
    func updateOrganization(organization: OrganizationDto, completion: @escaping (Result<EmptyDto, Error>) -> ())
    func getOrganizations(filter: FilterDto, completion: @escaping (Result<PaginatedDto<OrganizationDto>, Error>) -> ())
    func getOrganization(id: Int, completion: @escaping (Result<OrganizationDto, Error>) -> ())
}
