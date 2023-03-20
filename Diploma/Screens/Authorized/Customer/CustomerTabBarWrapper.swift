import SwiftUI

struct CustomerTabBarWrapper: View {
    public static let tag = "CustomerTabBarWrapper"
    @EnvironmentObject private var tools: ViewTools
    @State private var selectedTab: CustomTab = NavigationTabs.customerTabs[0]
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab.screenTag {
            case MainScreen.tag:
                MainScreen()
            case SuppliersListScreen.tag:
                SuppliersListScreen()
            case OrdersListScreen.tag:
                OrdersListScreen()
            case StatisticsScreen.tag:
                StatisticsScreen()
            case ProfileScreen.tag:
                ProfileScreen()
            default:
                Text("View doesnt exist")
                    .frame(maxHeight: .infinity)
            }
            
            BottomNavigation(navTabs: NavigationTabs.customerTabs, selectedTab: $selectedTab)
                .frame(height: tools.bottomBarIsVisible ? nil : 0)
                .clipped()
        }
        .defaultScreenSettings()
    }
}

struct CustomerTabBarWrapper_Previews: PreviewProvider {
    @StateObject static var viewTools = ViewTools()
    
    static var previews: some View {
        NavigationView {
            CustomerTabBarWrapper()
                .environmentObject(viewTools)
        }
    }
}
