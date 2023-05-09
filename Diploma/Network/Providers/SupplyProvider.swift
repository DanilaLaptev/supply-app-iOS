import Foundation
import Moya


enum SupplyProvider {
    case createSupply(supply: SupplyDto)
    case sellSupply(supply: SupplyDto)
    case getSupplies(filter: SupplyFilterDto)
    case declineSupply(supplyId: Int, branchId: Int)
    case acceptSupply(supplyId: Int, branchId: Int)
    case acceptSuppliesGroup(groupId: Int, branchId: Int)
    case declineSuppliesGroup(groupId: Int, branchId: Int)
}

extension SupplyProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/supplies") }
    
    var path: String {
        switch self {
        case .createSupply, .getSupplies:
            return "/"
        case .sellSupply:
            return "/sell"
        case .declineSupply(let supplyId, _):
            return "/\(supplyId)/decline"
        case .acceptSupply(let supplyId, _):
            return "/\(supplyId)/accept"
        case .acceptSuppliesGroup(let groupId, _):
            return "/group/\(groupId)/accept"
        case .declineSuppliesGroup(let groupId, _):
            return "/group/\(groupId)/decline"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createSupply, .declineSupply, .acceptSupply, .acceptSuppliesGroup, .declineSuppliesGroup, .sellSupply:
            return .post
        case .getSupplies:
            return .get
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .createSupply(let supply), .sellSupply(let supply):
            guard let body = CoderManager.encode(supply) else {
                return .requestPlain
            }
            
            return .requestData(body)
        case .getSupplies(let filter):
            guard let filterQuery = filter.dictionary else {
                return .requestPlain
            }
            return .requestParameters(parameters: filterQuery, encoding: URLEncoding.queryString)
        case .declineSupply(_, let branchId), .declineSuppliesGroup(_, let branchId):
            let params = ["organizationBranch" : branchId]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .acceptSupply(_, let branchId), .acceptSuppliesGroup(_, let branchId):
            let params = ["organizationBranch" : branchId]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    // TODO: real samples
    var sampleData: Data {
        switch self {
        case .createSupply:
            return .init()
        case .sellSupply:
            return .init()
        case .declineSupply:
            return .init()
        case .acceptSupply:
            return .init()
        case .getSupplies:
            return .init()
        case .acceptSuppliesGroup:
            return .init()
        case .declineSuppliesGroup:
            return .init()
        }
    }
    var headers: [String: String]? {
        return RequestHeader.withAccessToken
    }
}

extension SupplyProvider: MoyaCacheable {
  var cachePolicy: CachePolicy {
    switch self {
    default:
      return .reloadIgnoringLocalAndRemoteCacheData
    }
  }
}
