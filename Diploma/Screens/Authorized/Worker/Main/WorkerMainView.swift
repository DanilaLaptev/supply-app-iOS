import SwiftUI

struct WorkerMainView: View {
    public static let tag = "WorkerMainView"
    
    @StateObject private var tools = ViewManager.shared
    @StateObject private var viewModel = WorkerMainViewModel()

    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationLink("",
                           destination: EditProductScreen(initialStorageItem: viewModel.editedStorageItem),
                           isActive: $viewModel.editStorageItemActive)
            
            VStack {
                TagsGroup()
                .padding(.top, 8)
                .padding(.bottom, 16)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(viewModel.storageItems) { storageItem in
                            NavigationLink {
                                ProductScreen(model: storageItem)
                            } label:  {
                                DynamicProductCard(model: storageItem,
                                                   maximumQuantity: storageItem.quantity,
                                                   extraOptions: [
                                    ExtraOption(icon: .customPencil, action: {
                                        viewModel.editProduct(storageItem)
                                    })
                                ])
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 64)
                }
            }
            
            CustomButton(label: Text("Сохранить покупку"))
                .disabled(true)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = true
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkerMainView()
        }
    }
}
