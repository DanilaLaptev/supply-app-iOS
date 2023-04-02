import SwiftUI

struct SupplierTabBarWrapper: View {
    public static let tag = "SupplierTabBarWrapper"
    @StateObject private var tools = ViewManager.shared
    @State private var selectedTab: CustomTab = NavigationTabs.supplierTabs[0]
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab.screenTag {
            case SupplierMainScreen.tag:
                SupplierMainScreen()
            case SupplierClientsScreen.tag:
                SupplierClientsScreen()
            case ProfileScreen.tag:
                ProfileScreen()
            default:
                Text("View doesnt exist")
                    .frame(maxHeight: .infinity)
            }
            
            BottomNavigation(navTabs: NavigationTabs.supplierTabs, selectedTab: $selectedTab)
                .frame(height: tools.bottomBarIsVisible ? nil : 0)
                .clipped()
        }
        .defaultScreenSettings()
        .onAppear {
            tools.bottomBarIsVisible = true
        }
    }
}

struct SupplierTabBarWrapper_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierTabBarWrapper()
        }
    }
}
