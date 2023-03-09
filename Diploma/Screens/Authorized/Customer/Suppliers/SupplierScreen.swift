import SwiftUI

struct SupplierScreen: View {
    @EnvironmentObject var viewTools: ViewTools
    
    var body: some View {
        VStack(spacing: 0) {
            Header()
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ExtendableSection {
                        VStack {
                            SupplierAdditionalInfoRow(icon: .customMarker, hintText: "адрес склада", value: "ïåð. 7-é Íîâûé, 79, Òàãàíðîã")
                            SupplierAdditionalInfoRow(icon: .customRoute, hintText: "расстояние до вас", value: "3 км")
                            SupplierAdditionalInfoRow(icon: .customCall, hintText: "контактный номер", value: "+7 (999) 999-99-99")
                        }
                    } headerContent: {
                        Text("Подробная информация").font(.customSubtitle)
                    }
                    .padding(.horizontal, 16)
                    
                    Text("Позиции склада")
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
                            DynamicProductCard()
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 8)
            }
            
            BottomSheet {
                VStack(spacing: 8) {
                    HStack {
                        VStack {
                            Text("sdf").font(.customHint)
                            Text("sdf").font(.customSubtitle)
                        }
                        Spacer()
                        
                        NavigationLink(destination: OrderScreen()) {
                            CustomButton(icon: .customBox)
                                .frame(width: 48)
                        }
                    }
                    Text("Выберите хотя бы один продукт, чтобы оформить заказ")
                        .foregroundColor(.customDarkGray)
                        .font(.customHint)
                }
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .onAppear {
            viewTools.bottomBarIsVisible = false
        }
    }
}

struct SupplierScreen_Previews: PreviewProvider {
    @State static var tools = ViewTools()
    static var previews: some View {
        SupplierScreen()
            .environmentObject(tools)
    }
}
