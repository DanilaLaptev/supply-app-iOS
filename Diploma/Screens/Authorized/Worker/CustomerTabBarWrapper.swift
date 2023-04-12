import SwiftUI

struct CustomerTabBarWrapper: View {
    public static let tag = "CustomerTabBarWrapper"
    
    @StateObject private var viewManager = ViewManager.shared
    
    @State private var selectedTab: CustomTab = NavigationTabs.customerTabs[0]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab.screenTag {
                case WorkerMainView.tag:
                    WorkerMainView()
                case SuppliersListView.tag:
                    SuppliersListView()
                case WorkerSupplyListScreen.tag:
                    WorkerSupplyListScreen()
                case StatisticsScreen.tag:
                    StatisticsScreen()
                case ProfileScreen.tag:
                    ProfileScreen()
                default:
                    Text("View doesnt exist")
                        .frame(maxHeight: .infinity)
                }
            }
            .loadingWrapper($viewManager.isLoading)

            BottomNavigation(navTabs: NavigationTabs.customerTabs, selectedTab: $selectedTab)
                .frame(height: viewManager.bottomBarIsVisible ? nil : 0)
        }
        .defaultScreenSettings()
        .onAppear {
            viewManager.bottomBarIsVisible = true
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
