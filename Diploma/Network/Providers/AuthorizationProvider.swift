import Foundation
import Moya


enum AuthorizationProvider {
    case login(_ authDto: AuthorizationDto)
    case register(_ authDto: AuthorizationDto)
}

extension AuthorizationProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/auth") }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register:
            return .post
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .login(let authDto), .register(let authDto):
            guard let body = CoderManager.encode(authDto) else {
                return .requestPlain
            }
            
            return .requestData(body)
        }
    }
    
    // TODO: real samples
    var sampleData: Data {
        switch self {
        case .login:
            return .init()
        case .register:
            return .init()
        }
    }
    var headers: [String: String]? {
        return RequestHeader.standard
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data { Data(self.utf8) }
}
