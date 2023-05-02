import Foundation

struct AuthData {
    var organizationId: Int
    var branchId: Int?
    var token: String
    var role: OrganizationType
}

final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    private init() {}
    
    @Published private(set) var authData: AuthData? = nil
    
    func setData(_ authData: AuthData?) {
        self.authData = authData
    }
    
    func clearData() {
        authData = nil
    }
}
 
