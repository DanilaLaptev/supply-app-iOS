import SwiftUI

struct AuthorizationWrapper: View {
    public static let tag = "AuthorizationWrapper"

    
    @StateObject private var tools = ViewManager.shared
    @State var isUserAuthorized = false
    @State var userRole: UserRole = .supplier

    var body: some View {
        if isUserAuthorized {
            switch userRole {
            case .worker:
                CustomerTabBarWrapper()
            case .supplier:
                SupplierMainScreen()
            }
        } else {
            SignInScreen()
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
