import SwiftUI

struct EditProductScreen: View {
    @Environment(\.presentationMode) private var presentationMode

    public static let tag = "EditProductScreen"
    
    @StateObject var viewModel = EditProductViewModel()
    @Binding var initialStorageItem: StorageItemModel?
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Header(title: initialStorageItem?.product.name ?? "Title")
                
                AsyncImage(imageUrl: URL(string: initialStorageItem?.product.imageURL ?? "none"), placeholder: {
                    Color.customDarkGray
                })
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(8)
                    .padding(.bottom, 8)

                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(8)
                
                CustomTextField(textFieldValue: $viewModel.description, placeholder: "Описание")
                CustomTextField(textFieldValue: $viewModel.price, placeholder: "Цена").keyboardType(.numberPad)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            BottomSheet {
                CustomButton(label: Text("Сохранить").font(.customStandard)) {
                    viewModel.updateStorageItem()
                }
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            viewModel.updateBindings = self
            viewModel.navigation = self
            viewModel.setup(initialStorageItem)
        }
    }
    
}

extension EditProductScreen: NavigationProtocol {
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

extension EditProductScreen: UpdateBindingsProtocol {
    func update() {
        self.initialStorageItem?.description = viewModel.description
        self.initialStorageItem?.price = Double(viewModel.price) ?? 0
    }
}

struct EditProductScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProductScreen(initialStorageItem: .constant(.empty))
        }
    }
}
