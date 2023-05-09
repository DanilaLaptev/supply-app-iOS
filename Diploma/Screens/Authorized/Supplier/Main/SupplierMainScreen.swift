import SwiftUI

struct SupplierMainScreen: View {
    @StateObject var viewModel = SupplierMainViewModel()
    
    public static let tag = "SupplierMainScreen"
    @State var showEditProductScreen = false
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var tagSelection: String? = nil
    @State private var showDeleteProductAlert = false
    @State private var showCreateProductView = false

    var body: some View {
        VStack {
            NavigationLink(
                "",
                destination: ProductScreen(model: viewModel.selectedProduct ?? .empty),
                isActive: $viewModel.showProductScreen
            )
            
            NavigationLink(
                "",
                destination: EditProductScreen(initialStorageItem: viewModel.editedProduct),
                isActive: $viewModel.showEditScreen
            )
            
            NavigationLink(
                "",
                destination: CreateProductView(),
                isActive: $showCreateProductView
            )
                        
            SmallTagsGroup<ProductType>(selectedTags: $viewModel.selectedProductTypes)
            .padding(.top, 8)
            .padding(.bottom, 16)
            ScrollView(.vertical, showsIndicators: false) {
                AddProductButton  {
                    showCreateProductView.toggle()
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
                        } tapDeletingButton: {
                            self.showDeleteProductAlert.toggle()
                        }
                        .onAppear {
                            if viewModel.storageItems.last?.id == storageItem.id {
                                viewModel.fetchStorageItems()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .alert(isPresented: $showDeleteProductAlert) {
                    Alert(
                        title: Text("Удалить продукт"),
                        message: Text("Вы точно хотите удалить выбранный продукт?"),
                        primaryButton: .destructive(Text("Удалить")) {
                            // TODO: action
                        },
                        secondaryButton: .cancel(Text("Отмена"))
                    )
                }
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

struct SupplierMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierMainScreen()
        }
    }
}
