import SwiftUI

struct EditProductScreen: View {
    public static let tag = "EditProductScreen"
    
    @StateObject var viewModel = EditProductViewModel()
    var initialStorageItem: StorageItemModel? = nil
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Header(title: initialStorageItem?.product.name ?? "Title")
                
                // TODO: async image
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
            viewModel.setup(initialStorageItem)
        }
    }
    
}

struct EditProductScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProductScreen()
        }
    }
}
