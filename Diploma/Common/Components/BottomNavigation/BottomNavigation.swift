import SwiftUI

struct BottomNavigation: View {
    let navTabs: [CustomTab]
    let safeAreaInsets: EdgeInsets
    @Binding var selectedTab: CustomTab
    
    init(navTabs: [CustomTab], safeAreaInsets: EdgeInsets, selectedTab: Binding<CustomTab>) {
        self.navTabs = navTabs
        self.safeAreaInsets = safeAreaInsets
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(navTabs) { tab in
                    Spacer()
                    HStack {
                        tab.icon
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(tab == selectedTab ? .customOrange : .customGray)
                        
                        if tab == selectedTab {
                            Text(tab.name)
                                .font(.customStandard)
                                .foregroundColor(.customOrange)
                        }
                    }
                    .padding(6)
                    .background(Color.customLightOrange.opacity(tab == selectedTab ? 1 : 0))
                    .cornerRadius(8)
                    .animation(Animation.easeInOut(duration: 0.24))
                    .onTapGesture {
                        selectedTab = tab
                        print("tap \(tab.name)")
                    }
                    
                    Spacer()
                }
            }
        }
        .scaledToFit()
        .padding([.top, .horizontal], 8)
        .padding(.bottom, safeAreaInsets.bottom)
        .background(Color.customWhite)
        .cornerRadius(8, corners: [.topLeft, .topRight])
        .topShadow()
    }
}

struct BottomNavigation_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigation(navTabs: NavigationTabs.customerTabs, safeAreaInsets: EdgeInsets(), selectedTab: .constant(NavigationTabs.customerTabs[0]))
    }
}
