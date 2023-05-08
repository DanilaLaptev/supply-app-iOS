import SwiftUI

struct EditProductScreen: View {
    public static let tag = "EditProductScreen"
    
    @StateObject var viewModel = EditProductViewModel()
    var initialStorageItem: StorageItemModel? = nil
    
    @State private var isSharePresented = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Header(title: initialStorageItem?.product.name ?? "Title")
                
                // TODO: async image
                SelectedImage()
                    .padding(.bottom, 8)
                    .onTapGesture {
                        isSharePresented.toggle()
                    }
                    .sheet(isPresented: $isSharePresented) {
                        PhotoPicker(selectedImage: $selectedImage)
                    }
                
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
    
    @ViewBuilder
    func SelectedImage() -> some View {
        ZStack(alignment: .center) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .foregroundColor(Color.customWhite)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Image.customImage
                    .frame(width: 24, height: 24)
                    .foregroundColor(.customOrange)
            }
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .clipped()
        .cornerRadius(8)
    }
    
}

struct EditProductScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProductScreen()
        }
    }
}
