import Foundation

struct AuthData {
    let userId: Int
    let token: String
    let role: OrganizationType
}

final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    private init() { }
    
    @Published private(set) var authData: AuthData? = nil
    
    func setData(_ authData: AuthData?) {
        self.authData = authData
    }
    
    func clearData() {
        authData = nil
    }
}
