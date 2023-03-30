import SwiftUI

struct AuthorizationWrapper: View {
    public static let tag = "AuthorizationWrapper"

    @EnvironmentObject private var tools: ViewTools
    @State var isUserAuthorized = true
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
    @StateObject private static var tools = ViewTools()

    static var previews: some View {
        NavigationView {
            AuthorizationWrapper()
                .environmentObject(tools)
        }
    }
}
