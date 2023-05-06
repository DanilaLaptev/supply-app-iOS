import SwiftUI

struct SupplierView: View {
    public static let tag = "SupplierView"
    
    @StateObject private var viewModel = SupplierViewModel()
    @StateObject private var tools = ViewManager.shared
    @State private var tagSelection: String? = nil
    
    let organizationModel: OrganizationModel
    
    init(organizationModel: OrganizationModel) {
        self.organizationModel = organizationModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink("", destination: OrderingView(organizationModel: organizationModel, selectedItems: viewModel.selectedStorageItems), tag: OrderingView.tag, selection: $tagSelection)
            
            Header(title: organizationModel.title ?? "none")
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ExtendableSection {
                        VStack {
                            SupplierAdditionalInfoRow(icon: .customMarker, hintText: "адрес склада", value: organizationModel.branches.last?.address?.addressName ?? "-")
                            SupplierAdditionalInfoRow(icon: .customRoute, hintText: "расстояние до вас", value: "3 км")
                            SupplierAdditionalInfoRow(icon: .customCall, hintText: "контактный номер", value: organizationModel.branches.last?.contacts.last?.phone ?? "-")
                        }
                    } headerContent: {
                        Text("Подробная информация").font(.customSubtitle)
                    }
                    .padding(.horizontal, 16)
                    
                    Text("Позиции склада")
                        .font(.customTitle)
                        .padding(.horizontal, 16)
                    
                    SmallTagsGroup<ProductType>(selectedTags: $viewModel.selectedProductTypes)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    
                    VStack {
                        ForEach($viewModel.storageItems) { $wrappedItem in
                            NavigationLink {
                                ProductScreen(model: wrappedItem.item)
                            } label: {
                                DynamicProductCard(model: wrappedItem.item, extraOptions: [], selectedNumber: $wrappedItem.selectedAmmount)
                                    .onAppear {
                                        if viewModel.storageItems.last?.id == wrappedItem.item.id {
                                            viewModel.fetchStorageItems()
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 8)
            }
            
            BottomSheet {
                VStack(alignment: .center, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(viewModel.selectedItemsNumber) продуктов").font(.customHint)
                            Text("\(Int(viewModel.supplyTotalPrice)) ₽").font(.customSubtitle)
                        }
                        Spacer()
                        CustomButton(icon: .customBox) {
                            tagSelection = OrderingView.tag
                        }
                        .frame(width: 48)
                        .disabled(viewModel.disableSupplyButton)
                    }
                    
                    if viewModel.disableSupplyButton {
                        Text("Выберите продукты, чтобы оформить заказ")
                            .foregroundColor(.customDarkGray)
                            .font(.customHint)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = false
            viewModel.setup(organizationModel: self.organizationModel)
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
