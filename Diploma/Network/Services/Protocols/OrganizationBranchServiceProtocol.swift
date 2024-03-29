import Foundation

protocol OrganizationBranchServiceProtocol {
    func createOrganizationBranch(branch: OrganizationBranchDto, completion: @escaping (Result< OrganizationBranchDto, Error>) -> ())
    func updateOrganizationBranch(branchId: Int, branch: OrganizationBranchDto, completion: @escaping (Result<Void, Error>) -> ())
    func addContactPerson(branchId: Int, contactPerson: ContactPersonDto, completion: @escaping (Result<Void, Error>) -> ())
    func getStorageItems(branchId: Int, filter: FilterDto, completion: @escaping (Result<PaginatedDto<StorageItemDto>, Error>) -> ())
    func addStorageItems(branchId: Int, items: [StorageItemDto], completion: @escaping (Result<Void, Error>) -> ())
    func updateStorageItem(branchId: Int, item: StorageItemDto, completion: @escaping (Result<Void, Error>) -> ())
}
