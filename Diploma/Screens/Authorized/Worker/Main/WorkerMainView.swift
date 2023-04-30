import SwiftUI

struct WorkerMainView: View {
    public static let tag = "WorkerMainView"
    
    @StateObject private var tools = ViewManager.shared
    @StateObject private var viewModel = WorkerMainViewModel()
    
    @State private var showAlert = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationLink("",
                           destination: EditProductScreen(initialStorageItem: viewModel.editedStorageItem),
                           isActive: $viewModel.editStorageItemActive)
            
            VStack {
                TagsGroup<ProductType>()
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(viewModel.storageItems) { wrappedItem in
                            NavigationLink {
                                ProductScreen(model: wrappedItem.item)
                            } label:  {
                                DynamicProductCard(model: wrappedItem.item,
                                                   maximumQuantity: wrappedItem.item.quantity,
                                                   extraOptions: [
                                                    ExtraOption(icon: .customPencil, action: {
                                                        viewModel.editProduct(wrappedItem.item)
                                                    })
                                                   ],
                                                   selectedNumber: $viewModel.storageItems[viewModel.storageItems.firstIndex(of: wrappedItem)!].selectedAmmount)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 64)
                }
            }
            
            CustomButton(label: Text("Покупка на \(Int(viewModel.totalPrice)) ₽")) {
                self.showAlert = true
            }
            .disabled(viewModel.disableSupplyButton)
            .padding(.horizontal, 24)
            .padding(.bottom, 8)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Сохранить закупку"),
                    message: Text("Сохнаить покупку на \(Int(viewModel.totalPrice)) ₽?"),
                    primaryButton: .default(Text("Сохранить")) {
                        // TODO: action
                    },
                    secondaryButton: .cancel(Text("Отмена"))
                )
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = true
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkerMainView()
        }
    }
}
