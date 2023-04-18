import SwiftUI

struct OrderingView: View {
    public static let tag = "OrderingView"
    
    @StateObject private var tools = ViewManager.shared
    @StateObject private var viewModel = OrderingViewModel()
    @State private var showAlert = false
    
    var organizationModel: OrganizationModel
    var selectedItems: [StorageItemWrapper]
    
    init(organizationModel: OrganizationModel, selectedItems: [StorageItemWrapper]) {
        self.organizationModel = organizationModel
        self.selectedItems = selectedItems
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Header(title: "Оформление заказа")
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(viewModel.selectedProductsNumber) продуктов")
                            .font(.customTitle)
                            .padding(.horizontal, 16)
                        Spacer()
                    }
                    
                    VStack {
                        ForEach(viewModel.selectedItems ?? []) { wrappedItem in
                            StaticProductCard(storageItem: StorageItemModel(product: wrappedItem.item.product, imageUrl: "", price: wrappedItem.item.price, quantity: wrappedItem.selectedAmmount, description: ""))
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            
            BottomSheet {
                VStack(spacing: 32) {
                    VStack(alignment: .leading ,spacing: 16) {
                        Text("Выберите дату и время получения заказа").font(.customStandard)
                        VStack(spacing: 8) {
                            DatePickerField(date: $viewModel.date, icon: .customDate)
                        }
                    }
                    
                    CustomButton(label: Text("Оформить заказ на \(Int(viewModel.totalPrice)) ₽")) {
                        self.showAlert = true
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Оформление заказа"),
                            message: Text("Вы точно хотите оформить заказ на \(Int(viewModel.totalPrice)) ₽?"),
                            primaryButton: .default(Text("Оформить")) {
                                // TODO: action
                            },
                            secondaryButton: .cancel(Text("Отмена"))
                        )
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = false
            self.viewModel.setup(organizationModel: self.organizationModel, selectedItems: self.selectedItems)
        }
    }
}

struct OrderingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OrderingView(organizationModel: .empty, selectedItems: [])
        OrderingView(organizationModel: .test, selectedItems: [])
    }
}
