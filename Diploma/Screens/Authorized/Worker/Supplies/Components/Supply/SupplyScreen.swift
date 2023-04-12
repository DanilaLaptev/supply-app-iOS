import SwiftUI

struct SupplyScreen: View {
    let supplyModel: SupplyModel
    
    @StateObject var viewModel = SupplyViewModel()
    
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
                    
                    if let commentary = viewModel.supplyModel?.fromOrganizationCommentary {
                        ExtendableSection {
                            Text(commentary).font(.customStandard)
                        } headerContent: {
                            HStack(spacing: 8) {
                                switch supplyModel.statusHistory.first?.status ?? .denied {
                                case .denied:
                                    Image.customErrorAlert.frame(width: 24, height: 24)
                                default:
                                    Image.customSuccessAlert.frame(width: 24, height: 24)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Заказ отклонён").font(.customSubtitle)
                                    Text("Комментарий продавца").font(.customHint)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
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
                VStack {
                    CustomButton(label: Text("Приём заказа").font(.customStandard))
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
