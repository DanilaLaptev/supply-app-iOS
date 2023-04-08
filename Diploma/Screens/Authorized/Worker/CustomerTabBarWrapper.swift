import SwiftUI

struct CustomerTabBarWrapper: View {
    public static let tag = "CustomerTabBarWrapper"
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var selectedTab: CustomTab = NavigationTabs.customerTabs[0]
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab.screenTag {
            case WorkerMainView.tag:
                WorkerMainView()
            case SuppliersListView.tag:
                SuppliersListView()
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
        }
        .defaultScreenSettings()
        .onAppear {
            tools.bottomBarIsVisible = true
        }
    }
}

struct CustomerTabBarWrapper_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomerTabBarWrapper()
        }
    }
}
