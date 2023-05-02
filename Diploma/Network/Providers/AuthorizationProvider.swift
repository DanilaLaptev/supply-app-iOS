import Foundation
import Moya


enum AuthorizationProvider {
    case check
    case login(_ authDto: AuthorizationDto)
    case register(_ authDto: AuthorizationDto)
}

extension AuthorizationProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/auth") }
    
    var path: String {
        switch self {
        case .check:
            return "/check"
        case .login:
            return "/login"
        case .register:
            return "/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .check:
            return .get
        case .login, .register:
            return .post
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .check:
            return .requestPlain
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
        case .check:
            return .init()
        case .login:
            return .init()
        case .register:
            return .init()
        }
    }
    var headers: [String: String]? {
        switch self {
        case .check:
            return RequestHeader.withAccessToken
        default:
            return RequestHeader.standard
        }
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data { Data(self.utf8) }
}
