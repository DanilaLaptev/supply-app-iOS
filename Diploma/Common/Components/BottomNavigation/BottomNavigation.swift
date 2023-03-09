import SwiftUI

struct BottomNavigation: View {
    var navTabs: [CustomTab]
    @Binding var selectedTab: CustomTab
    
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
        .padding(8)
        .padding(.bottom, safeAreaEdgeInsets.bottom)
        .background(Color.customWhite)
        .cornerRadius(8, corners: [.topLeft, .topRight])
        .topShadow()
    }
}

struct BottomNavigation_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigation(navTabs: NavigationTabs.customerTabs, selectedTab: .constant(NavigationTabs.customerTabs[0]))
    }
}
