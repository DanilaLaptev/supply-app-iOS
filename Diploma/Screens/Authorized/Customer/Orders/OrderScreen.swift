import SwiftUI

struct OrderScreen: View {
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Header {
                        
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    
                    ExtendableSection {
                        ScrollView(.vertical) {
                            VStack {
                                ForEach((0...8), id: \.self) { _ in
                                    StaticProductCard(name: "name", price: 100, itemsNumber: 12)
                                }
                            }
                        }
                        .frame(maxHeight: 320)
                    } headerContent: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Список продуктов").font(.customSubtitle)
                            Text("Общая стоимость 500 ₽").font(.customHint)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    
                    Text("Статус заказа")
                        .font(.customTitle)
                        .padding(.horizontal, 16)
                    
                    
                    // TODO:
                    VStack(spacing: 0) {
                        OrderStateView(stepState: .current)
                        ForEach(1...8, id: \.self) { _ in
                            OrderStateView(stepState: .passed)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 8)
            }
            
            BottomSheet {
                NavigationLink(destination: OrderScreen()) {
                    CustomButton(label: Text("Приём заказа").font(.customStandard))
                }
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
    }
}

struct OrderScreen_Previews: PreviewProvider {
    static var previews: some View {
        OrderScreen()
    }
}
