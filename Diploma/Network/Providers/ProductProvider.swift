import Foundation
import Moya


enum ProductProvider {
    case getAllProducts
    case createProduct
}

extension ProductProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/product") }
    
    var path: String {
        switch self {
        case .getAllProducts:
            return "/"
        case .createProduct:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllProducts:
            return .get
        case .createProduct:
            return .get
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .getAllProducts:
            return .requestPlain
        case .createProduct:
            return .requestPlain
        }
    }
    
    // TODO: real samples
    var sampleData: Data {
        switch self {
        case .getAllProducts:
            return .init()
        case .createProduct:
            return .init()
        }
    }
    var headers: [String: String]? {
        return RequestHeader.withAccessToken
    }
}


extension ProductProvider: MoyaCacheable {
    var cachePolicy: CachePolicy {
        switch self {
        case .getAllProducts:
            return .returnCacheDataElseLoad
        default:
            return .reloadIgnoringLocalAndRemoteCacheData
        }
    }
}
