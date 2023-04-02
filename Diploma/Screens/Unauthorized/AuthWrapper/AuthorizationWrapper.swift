import SwiftUI

struct AuthorizationWrapper: View {
    public static let tag = "AuthorizationWrapper"

    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        if authManager.authData != nil,
           let authData = authManager.authData {
            switch authData.role {
            case .worker:
                CustomerTabBarWrapper()
            case .supplier:
                SupplierTabBarWrapper()
            }
        } else {
            SignInView()
        }
    }
}

struct AuthorizationWrapper_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AuthorizationWrapper()
        }
    }
}
