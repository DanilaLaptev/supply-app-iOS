import Foundation
import Moya

enum AuthorizationProvider {
    case login
    case logout
    case register
    case checkAuth
    case checkEmail
}

extension AuthorizationProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/authorization") }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .logout:
            return "/logout"
        case .register:
            return "/register"
        case .checkAuth:
            return "/check-auth"
        case .checkEmail:
            return "/check-email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register, .logout:
            return .post
        case .checkAuth, .checkEmail:
            return .get
        }
    }
        
    // TODO: data for requests
    var task: Task {
        switch self {
        case .login:
            return .requestPlain
        case .logout:
            return .requestPlain
        case .register:
            return .requestPlain
        case .checkAuth:
            return .requestPlain
        case .checkEmail:
            return .requestPlain
        }
    }
    
    // TODO: real samples
    var sampleData: Data {
        switch self {
        case .login:
            return .init()
        case .logout:
            return .init()
        case .register:
            return .init()
        case .checkAuth:
            return .init()
        case .checkEmail:
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
