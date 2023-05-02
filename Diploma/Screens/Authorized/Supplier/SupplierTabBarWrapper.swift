import SwiftUI

struct SupplierTabBarWrapper: View {
    public static let tag = "SupplierTabBarWrapper"
    @StateObject private var viewManager = ViewManager.shared
    @State private var selectedTab: CustomTab = NavigationTabs.supplierTabs[0]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab.screenTag {
                case SupplierMainScreen.tag:
                    SupplierMainScreen()
                case ClientsListView.tag:
                    ClientsListView()
                case SupplierOrdersView.tag:
                    SupplierOrdersView()
                case SupplierStatisticsView.tag:
                    SupplierStatisticsView()
                case ProfileView.tag:
                    ProfileView()
                default:
                    Text("View doesnt exist")
                        .frame(maxHeight: .infinity)
                }
            }
            .loadingWrapper($viewManager.isLoading)
            
            BottomNavigation(navTabs: NavigationTabs.supplierTabs, selectedTab: $selectedTab)
                .frame(height: viewManager.bottomBarIsVisible ? nil : 0)
        }
        .defaultScreenSettings()
        .onAppear {
            viewManager.bottomBarIsVisible = true
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
