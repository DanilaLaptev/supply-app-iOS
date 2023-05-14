import Foundation
import Moya

struct OrganizationBranchService: OrganizationBranchServiceProtocol {
    private let provider: MoyaProvider<OrganizationBranchProvider>
    
    init(provider: MoyaProvider<OrganizationBranchProvider> = MoyaProvider<OrganizationBranchProvider>(plugins: [NetworkLoggerPlugin()])) {
        self.provider = provider
    }
    
    func createOrganizationBranch(branch: OrganizationBranchDto, completion: @escaping (Result<OrganizationBranchDto, Error>) -> ()) {
        provider.request(.createOrganizationBranch(branch: branch)) { result in
            completion(result.handleResponse(OrganizationBranchDto.self))
        }
    }
    
    func updateOrganizationBranch(branchId: Int, branch: OrganizationBranchDto, completion: @escaping (Result<Void , Error>) -> ()) {
        provider.request(.updateOrganizationBranch(branchId: branchId, branch: branch)) { result in
            completion(result.ignoreResponse())
        }
    }
    
    func addContactPerson(branchId: Int, contactPerson: ContactPersonDto, completion: @escaping (Result<Void , Error>) -> ()) {
        provider.request(.addContactPerson(branchId: branchId, contactPerson: contactPerson)) { result in
            completion(result.ignoreResponse())
        }
    }
    
    func getStorageItems(branchId: Int, filter: FilterDto, completion: @escaping (Result<PaginatedDto<StorageItemDto>, Error>) -> ()) {
        provider.request(.getStorageItems(branchId: branchId, filter: filter)) { result in
            completion(result.handleResponse(PaginatedDto<StorageItemDto>.self))
        }
    }
    
    func addStorageItems(branchId: Int, items: [StorageItemDto], completion: @escaping (Result<Void, Error>) -> ()) {
        provider.request(.addStorageItems(branchId: branchId, items: items)) { result in
            completion(result.ignoreResponse())
        }
    }
    
    func updateStorageItem(branchId: Int, item: StorageItemDto, completion: @escaping (Result<Void, Error>) -> ()) {
        provider.request(.updateStorageItem(branchId: branchId, item: item)) { result in
            completion(result.ignoreResponse())
        }
    }
}
