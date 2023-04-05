import SwiftUI

struct EditProductScreen: View {
    public static let tag = "EditProductScreen"
    @State var isSharePresented = false
    
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Header(title: "Title")
                
                // TODO: async image
                SelectedImage()
                    .padding(.bottom, 8)
                    .onTapGesture {
                        isSharePresented.toggle()
                    }
                    .sheet(isPresented: $isSharePresented) {
                        PhotoPicker(selectedImage: $selectedImage)
                    }
                
                CustomTextField(textFieldValue: .constant(""), placeholder: "Цена")
                CustomTextField(textFieldValue: .constant(""), placeholder: "Описание")
                CustomTextField(textFieldValue: .constant(""), placeholder: "Состав")
                CustomTextField(textFieldValue: .constant(""), placeholder: "Пищевая ценность")
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            BottomSheet {
                NavigationLink(destination: OrderScreen()) {
                    CustomButton(label: Text("Сохранить").font(.customStandard))
                }
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
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
