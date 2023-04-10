import SwiftUI
import Combine

struct SupplierOrdersView: View {
    public static let tag = "SupplierOrdersView"
    
    @StateObject var viewModel = SupplierOrdersViewModel()
    @StateObject private var tools = ViewManager.shared

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
                            SmallTag(icon: .customBox, name: "Box", isSelected: false)
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
                            StaticProductCard(storageItem: .empty)
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
            self.tools.bottomBarIsVisible = true
        }
    }
}

struct SupplierOrdersViewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierOrdersView()
        }
    }
}
