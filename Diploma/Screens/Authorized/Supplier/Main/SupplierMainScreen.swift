import SwiftUI

struct SupplierMainScreen: View {
    @StateObject var viewModel = SupplierMainViewModel()
    
    public static let tag = "SupplierMainScreen"
    @State var showEditProductScreen = false
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var tagSelection: String? = nil

    var body: some View {
        VStack {
            NavigationLink(
                destination: ProductScreen(model: viewModel.selectedProduct ?? .empty),
                isActive: $viewModel.showProductScreen,
                label: { }
            )
            
            NavigationLink(
                destination: EditProductScreen(initialStorageItem: $viewModel.editedProduct),
                isActive: $viewModel.showEditScreen,
                label: { }
            )
            
            NavigationLink(
                destination: CreateProductView(newProductCreated: $viewModel.newProductCreated),
                isActive: $viewModel.showCreateProductView,
                label: { }
            )
            
            SmallTagsGroup<ProductType>(selectedTags: $viewModel.selectedProductTypes)
            .padding(.top, 8)
            .padding([.leading, .bottom], 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                AddProductButton  {
                    viewModel.showCreateProductView.toggle()
                }
                .padding(.horizontal, 16)
                .alert(isPresented: $viewModel.showHideProductAlert) {
                    Alert(
                        title: Text("Видимость продукта"),
                        message: Text("Вы точно хотите изменить видимость выбранного продукт?"),
                        primaryButton: .default(Text("Изменить")) {
                            viewModel.hideProductRequest()
                        },
                        secondaryButton: .cancel(Text("Отмена"))
                    )
                }
                
                VStack {
                    ForEach(viewModel.storageItems) { storageItem in
                        SupplierProductCard(model: storageItem) {
                            viewModel.openProductView(storageItem)
                        } tapEditingButton: {
                            viewModel.openEditView(storageItem)
                        } tapVisibilityButton : {
                            viewModel.hideStorageItem(storageItem)
                        }
                        .onAppear {
                            if viewModel.storageItems.last?.id == storageItem.id {
                                viewModel.fetchStorageItems()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = true
        }
    }
}

struct SupplierMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierMainScreen()
        }
    }
}
