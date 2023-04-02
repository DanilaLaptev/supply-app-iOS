import SwiftUI

struct SupplierScreen: View {
    public static let tag = "SupplierScreen"

    
    @StateObject private var tools = ViewManager.shared
    @State private var tagSelection: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            Header(title: "Title")
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
                            NavigationLink {
                                ProductScreen()
                            } label: {
                                DynamicProductCard()
                            }
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
                            NavigationLink(destination: OrderingScreen(), tag: OrderingScreen.tag, selection: $tagSelection) {
                                CustomButton(icon: .customBox) {
                                    tagSelection = OrderingScreen.tag
                                }
                                .frame(width: 48)
                            }
                            
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
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = false
        }
    }
}

struct SupplierScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierScreen()
        }
    }
}
