import SwiftUI
import Combine

struct CreateProductView: View {
    public static let tag = "EditProductScreen"
    
    @StateObject var viewModel = CreateProductViewModel()
    
    var body: some View {
        OverflowScroll {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        Header(title: "Новый продукт")
                        
                        ProductPicker(selectedItem: $viewModel.product, items: viewModel.products) {
                            viewModel.fetchProductsList()
                        }
                        
                        // TODO: async image
                        AsyncImage(imageUrl: URL(string: viewModel.imageUrl)) {
                            Color.customDarkGray
                        }
                        .frame(height: 200)
                        .cornerRadius(8)
                        .padding(.bottom, 8)
                        
                        CustomTextField(textFieldValue: $viewModel.description, placeholder: "Описание")
                        CustomTextField(textFieldValue: $viewModel.price, placeholder: "Цена").keyboardType(.numberPad)
                    }
                    .padding(.horizontal, 16)
                }
                
                Spacer()
                
                BottomSheet {
                    CustomButton(label: Text("Добавить").font(.customStandard)) {
                        viewModel.createStorageItem()
                    }
                }
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct CreateProductViewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateProductView()
        }
    }
}
