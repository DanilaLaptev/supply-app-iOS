import SwiftUI
import Combine

struct CreateProductView: View {
    public static let tag = "EditProductScreen"
    
    @StateObject var viewModel = CreateProductViewModel()
    var initialStorageItem: StorageItemModel? = nil
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Header(title: initialStorageItem?.product.name ?? "Title")
                
                // TODO: async image
                AsyncImage(imageUrl: URL(string: viewModel.imageUrl)) {
                    Color.customDarkGray
                }
                .frame(height: 200)
                .cornerRadius(8)
                .padding(.bottom, 8)
                
//                Picker(selection: $selectedItem, label: Text("Выберите продукт")) {
//                    ForEach(items, id: \.self) { item in
//                        Text(item).tag(item)
//                    }
//                }
//                .pickerStyle(MenuPickerStyle())
                
                CustomTextField(textFieldValue: $viewModel.description, placeholder: "Описание")
                CustomTextField(textFieldValue: $viewModel.price, placeholder: "Цена").keyboardType(.numberPad)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            BottomSheet {
                CustomButton(label: Text("Добавить").font(.customStandard)) {
                    viewModel.createStorageItem()
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

struct CreateProductViewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateProductView()
        }
    }
}
