import SwiftUI

struct SupplyScreen: View {
    let supplyModel: SupplyModel
    
    @StateObject var viewModel = SupplyViewModel()
    @State private var showAlert = false

    private var totalPrice: Double {
        viewModel.supplyModel?.totalPrice ?? 0
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Header(title: "№ \(viewModel.supplyModel?.publicId ?? 0)") { }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    
                    SupplyHeader(supplyModel: supplyModel)
                        .padding(.horizontal , 16)

                    ExtendableSection {
                        ScrollView(.vertical) {
                            VStack {
                                ForEach(supplyModel.products) { storageItem in
                                    StaticProductCard(storageItem: storageItem)
                                }
                            }
                        }
                        .frame(maxHeight: 320)
                    } headerContent: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Список продуктов").font(.customSubtitle)
                            Text("Общая стоимость \(Int(totalPrice)) ₽").font(.customHint)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Text("Статус заказа")
                        .font(.customTitle)
                        .padding(.horizontal, 16)
                    
                    SupplyHistoryList(history: viewModel.supplyModel?.statusHistory ?? [])
                    .padding(.horizontal, 16)
                }
                .padding(.top, 8)
            }
            
            BottomSheet {
                VStack {
                    CustomButton(label: Text("Приём заказа").font(.customStandard)) {
                        self.showAlert = true
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Прием заказа"),
                            message: Text("Вы проверили доставленные продукты и готовы принять заказ?"),
                            primaryButton: .default(Text("Принять")) {
                                viewModel.acceptSupply()
                            },
                            secondaryButton: .cancel(Text("Отмена"))
                        )
                    }
                    .disabled(viewModel.disableAcceptButton)
                    
                    Text("Принять можно только доставленный товар!")
                        .font(.customHint)
                        .foregroundColor(.customBlack)
                }
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.viewModel.setup(supplyModel: self.supplyModel)
        }
    }
}

struct SupplyScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplyScreen(supplyModel: .empty)
        }
    }
}
