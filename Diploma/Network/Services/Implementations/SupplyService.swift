import Foundation
import Moya

struct SupplyService: SupplyServiceProtocol {
    private let provider: MoyaProvider<SupplyProvider>
    
    init(provider: MoyaProvider<SupplyProvider> = MoyaProvider<SupplyProvider>(plugins: [NetworkLoggerPlugin()])) {
        self.provider = provider
    }
    
    func createSupply(supply: SupplyDto, completion: @escaping (Result<Void, Error>) -> ()) {
        provider.request(.createSupply(supply: supply)) { result in
            completion(result.ignoreResponse())
        }
    }
    
    func sellSupply(supply: SupplyDto, completion: @escaping (Result<Void, Error>) -> ()) {
        provider.request(.sellSupply(supply: supply)) { result in
            completion(result.ignoreResponse())
        }
    }
    
    func getSupplies(filter: SupplyFilterDto, completion: @escaping (Result<[SupplyDto], Error>) -> ()) {
        provider.request(.getSupplies(filter: filter)) { result in
            completion(result.handleResponse([SupplyDto].self))
        }
    }
    
    func declineSupply(supplyId: Int, branchId: Int, completion: @escaping (Result<Void, Error>) -> ()) {
        provider.request(.declineSupply(supplyId: supplyId, branchId: branchId)) { result in
            completion(result.ignoreResponse())
        }
    }
    
    func acceptSupply(supplyId: Int, branchId: Int, completion: @escaping (Result<Void, Error>) -> ()) {
        provider.request(.acceptSupply(supplyId: supplyId, branchId: branchId)) { result in
            completion(result.ignoreResponse())
        }
    }
    
    func acceptSuppliesGroup(groupId: Int, branchId: Int, completion: @escaping (Result<Void, Error>) -> ()) {
        provider.request(.acceptSuppliesGroup(groupId: groupId, branchId: branchId)) { result in
            completion(result.ignoreResponse())
        }
    }
    
    func declineSuppliesGroup(groupId: Int, branchId: Int, completion: @escaping (Result<Void, Error>) -> ()) {
        provider.request(.declineSuppliesGroup(groupId: groupId, branchId: branchId)) { result in
            completion(result.ignoreResponse())
        }
    }
}
