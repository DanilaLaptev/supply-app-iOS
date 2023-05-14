import SwiftUI

struct SupplierOrderView: View {
    let supplyModel: SupplyModel
    
    @StateObject var viewModel = SupplierOrderViewModel()
    @State private var showBottomSheet = false

    private var totalPrice: Double {
        viewModel.supplyModel?.totalPrice ?? 0
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Header(title: "№ \(viewModel.supplyModel?.publicId ?? 0)")
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
                    CustomButton(label: Text("Рассмотреть заказ").font(.customStandard)) {
                        self.showBottomSheet = true
                    }
                    .disabled(viewModel.disableAcceptButton)
                    
                    if viewModel.disableAcceptButton {
                        Text("Вы уже приняли решение по этому заказу!")
                            .font(.customHint)
                            .foregroundColor(.customBlack)
                    }
                }
            }
            .sheet(isPresented: $showBottomSheet) {
                OrderReviewView(supplyModel: supplyModel)
                    .environmentObject(viewModel)
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

struct SupplierOrderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierOrderView(supplyModel: .empty)
        }
    }
}
