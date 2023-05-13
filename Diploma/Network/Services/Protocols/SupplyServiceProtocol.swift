import Foundation

protocol SupplyServiceProtocol {
    func createSupply(supply: SupplyDto, completion: @escaping (Result<EmptyDto, Error>) -> ())
    func sellSupply(supply: SupplyDto, completion: @escaping (Result<EmptyDto, Error>) -> ())
    func getSupplies(filter: SupplyFilterDto, completion: @escaping (Result<[SupplyDto], Error>) -> ())
    func declineSupply(supplyId: Int, branchId: Int, completion: @escaping (Result<EmptyDto, Error>) -> ())
    func acceptSupply(supplyId: Int, branchId: Int, completion: @escaping (Result<EmptyDto, Error>) -> ())
    func acceptSuppliesGroup(groupId: Int, branchId: Int, completion: @escaping (Result<EmptyDto, Error>) -> ())
    func declineSuppliesGroup(groupId: Int, branchId: Int, completion: @escaping (Result<EmptyDto, Error>) -> ())
}
