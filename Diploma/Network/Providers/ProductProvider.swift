import Foundation
import Moya


enum ProductProvider {
    
}

extension ProductProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/product") }
    
    var path: String {
        switch self {

        }
    }
    
    var method: Moya.Method {
        switch self {

        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {

        }
    }
    
    // TODO: real samples
    var sampleData: Data {
        switch self {

        }
    }
    var headers: [String: String]? {
        return RequestHeader.standard
    }
}
