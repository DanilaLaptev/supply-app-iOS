import SwiftUI

struct SupplierView: View {
    public static let tag = "SupplierView"

    var organizationModel: OrganizationModel
    
    @StateObject private var viewModel = SupplierViewModel()
    @StateObject private var tools = ViewManager.shared
    @State private var tagSelection: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            Header(title: organizationModel.title)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ExtendableSection {
                        VStack {
                            SupplierAdditionalInfoRow(icon: .customMarker, hintText: "адрес склада", value: organizationModel.address.addressName ?? "-")
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
                    
                    TagsGroup()
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    
                    VStack {
                        ForEach(organizationModel.storageItems) { storageItem in
                            NavigationLink {
                                ProductScreen(model: storageItem)
                            } label: {
                                DynamicProductCard(model: storageItem, extraOptions: [])
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
                        VStack(alignment: .leading, spacing: 4) {
                            Text("продуктов").font(.customHint)
                            Text("100 ₽").font(.customSubtitle)
                        }
                        Spacer()
                        
                        NavigationLink(destination: OrderScreen()) {
                            NavigationLink(destination: OrderingView(organizationModel: organizationModel), tag: OrderingView.tag, selection: $tagSelection) {
                                CustomButton(icon: .customBox) {
                                    tagSelection = OrderingView.tag
                                }
                                .frame(width: 48)
                                .disabled(organizationModel.storageItems.isEmpty) // TODO: fix condition
                            }
                            
                        }
                    }
                    Text("Выберите хотя бы один продукт, чтобы оформить заказ")
                        .foregroundColor(.customDarkGray)
                        .font(.customHint)
                        .opacity(organizationModel.storageItems.isEmpty ? 1 : 0) // TODO: fix condition
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
            SupplierView(organizationModel: .empty)
        }
    }
}
