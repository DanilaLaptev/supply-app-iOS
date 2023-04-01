import Foundation

struct AuthData {
    let userId: Int
    let token: String
}

final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    private init() { }
    
    private(set) var authData: AuthData? = nil
    
    func setData(userId: Int, token: String) {
        authData = AuthData(userId: userId, token: token)
    }
    
    func setData(_ authData: AuthData) {
        self.authData = authData
    }
    
    func clearData() {
        authData = nil
    }
}
