import SwiftUI

struct OrdersListScreen: View {
    public static let tag = "OrdersListScreen"
    
    @EnvironmentObject private var tools: ViewTools
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                CalendarView()
                    .padding([.horizontal, .bottom], 16)
                
                Text("Заказы на 25 февраля")
                    .font(.customTitle)
                    .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach((0...16), id: \.self) { _ in
                            SmallTag(icon: .customClock, name: "tag")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }
                
                VStack {
                    ForEach((0...8), id: \.self) { _ in
                        NavigationLink {
                            OrderScreen()
                        } label: {
                            StaticProductCard(name: "Название", price: 100, itemsNumber: 12)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 8)
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            tools.setBottomBarVisibility(true)
        }
    }
}

struct OrdersScreen_Previews: PreviewProvider {
    @StateObject static var viewTools = ViewTools()
    
    static var previews: some View {
        NavigationView {
            OrdersListScreen()
                .environmentObject(viewTools)
        }
    }
}