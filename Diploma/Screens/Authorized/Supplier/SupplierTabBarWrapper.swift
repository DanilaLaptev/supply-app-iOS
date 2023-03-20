import SwiftUI

struct SupplierTabBarWrapper: View {
    public static let tag = "SupplierTabBarWrapper"
    @EnvironmentObject private var tools: ViewTools
    @State private var selectedTab: CustomTab = NavigationTabs.supplierTabs[0]
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab.screenTag {
            case SupplierMainScreen.tag:
                SupplierMainScreen()
            case SupplierClientsScreen.tag:
                SupplierClientsScreen()
            default:
                Text("View doesnt exist")
                    .frame(maxHeight: .infinity)
            }
            
            BottomNavigation(navTabs: NavigationTabs.supplierTabs, selectedTab: $selectedTab)
                .frame(height: tools.bottomBarIsVisible ? nil : 0)
                .clipped()
        }
        .defaultScreenSettings()
    }
}

struct SupplierTabBarWrapper_Previews: PreviewProvider {
    @StateObject static var viewTools = ViewTools()
    
    static var previews: some View {
        NavigationView {
            SupplierTabBarWrapper()
                .environmentObject(viewTools)
        }
    }
}