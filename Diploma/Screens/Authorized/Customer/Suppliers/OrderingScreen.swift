import SwiftUI

struct OrderingScreen: View {
    @EnvironmentObject var viewTools: ViewTools

    var body: some View {
        VStack(spacing: 0) {
            Header()
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("5 продуктов")
                        .font(.customTitle)
                        .padding(.horizontal, 16)

                    VStack {
                        ForEach((0...8), id: \.self) { _ in
                            DynamicProductCard()
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 8)
            }
            
            BottomSheet {
                VStack(spacing: 32) {
                    VStack(alignment: .leading ,spacing: 16) {
                        Text("Выберите дату и время получения заказа").font(.customStandard)
                        VStack(spacing: 8) {
                            CustomTextField(icon: .customDate, placeholder: "Дата")
                            CustomTextField(icon: .customClock, placeholder: "Время")
                        }
                    }
                    
                    CustomButton(label: Text("Оформить заказ на 500 ₽"))
                }
                .padding(.vertical, 8)
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .onAppear {
            viewTools.bottomBarIsVisible = false
        }
    }
}

struct OrderingScreen_Previews: PreviewProvider {
    @State static var tools = ViewTools()

    static var previews: some View {
        OrderingScreen()
            .environmentObject(tools)
    }
}
