import SwiftUI

struct ContentView: View {
    @State private var selectedTab: CustomTab = NavigationTabs.customerTabs[0]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    MainScreen()
                }
                .frame(maxHeight: .infinity)
                BottomNavigation(navTabs: NavigationTabs.customerTabs,
                                 safeAreaInsets: geometry.safeAreaInsets,
                                 selectedTab: $selectedTab)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

