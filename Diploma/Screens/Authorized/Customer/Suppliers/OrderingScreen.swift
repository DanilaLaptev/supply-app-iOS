import SwiftUI

struct OrderingScreen: View {
    public static let tag = "OrderingScreen"

    
    @StateObject private var tools = ViewManager.shared

    var body: some View {
        VStack(spacing: 0) {
            Header(title: "Title")
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
                            CustomTextField(textFieldValue: .constant(""), icon: .customDate, placeholder: "Дата")
                            CustomTextField(textFieldValue: .constant(""), icon: .customClock, placeholder: "Время")
                        }
                    }
                    
                    CustomButton(label: Text("Оформить заказ на 500 ₽"))
                }
                .padding(.vertical, 8)
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = false
        }
    }
}

struct OrderingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OrderingScreen()
    }
}
