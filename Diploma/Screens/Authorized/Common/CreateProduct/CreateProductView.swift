import SwiftUI
import Combine

struct CreateProductView: View {
    @Environment(\.presentationMode) private var presentationMode

    public static let tag = "EditProductScreen"
    
    @StateObject var viewModel = CreateProductViewModel()
    @Binding var newProductCreated: Bool
    
    var body: some View {
        OverflowScroll {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        Header(title: "Новый продукт")
                        
                        ProductPicker(selectedItem: $viewModel.product, items: viewModel.products) {
                            viewModel.fetchProductsList()
                        }
                        
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
        .onAppear {
            viewModel.updateBindings = self
            viewModel.navigation = self
        }
    }
}

extension CreateProductView: NavigationProtocol {
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

extension CreateProductView: UpdateBindingsProtocol {
    func update() {
        newProductCreated = true
    }
}

struct CreateProductViewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateProductView(newProductCreated: .constant(false))
        }
    }
}
