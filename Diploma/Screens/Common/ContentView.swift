import SwiftUI

struct ContentView: View {
    @State private var selectedTab: CustomTab = NavigationTabs.customerTabs[0]
    @StateObject private var viewTools = ViewTools()
    
    var body: some View {
            VStack(spacing: 0) {
                NavigationView {
                    SupplierMainScreen()
                        .edgesIgnoringSafeArea(.all)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                }
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
                
                if viewTools.bottomBarIsVisible {
                    BottomNavigation(navTabs: NavigationTabs.customerTabs,
                                     selectedTab: $selectedTab)
                }
            }
            .background(Color.customLightGray.edgesIgnoringSafeArea(.all))
            .environmentObject(viewTools)
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
