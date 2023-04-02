import SwiftUI

struct EditProductScreen: View {
    public static let tag = "EditProductScreen"
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Header(title: "Title")

                // TODO: async image
                ZStack(alignment: .center) {
                    Rectangle()
                        .foregroundColor(Color.customWhite)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                    
                    Image.customBox
                        .frame(width: 24, height: 24)
                        .foregroundColor(.customOrange)
                }
                .padding(.bottom, 8)
                
                CustomTextField(textFieldValue: .constant(""), placeholder: "Цена")
                CustomTextField(textFieldValue: .constant(""), placeholder: "Описание")
                CustomTextField(textFieldValue: .constant(""), placeholder: "Состав")
                CustomTextField(textFieldValue: .constant(""), placeholder: "Пищевая ценность")
            }
            .padding(.horizontal, 16)

            Spacer()
            
            BottomSheet {
                NavigationLink(destination: OrderScreen()) {
                    CustomButton(label: Text("Опубликовать новую позицию").font(.customStandard))
                }
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct EditProductScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProductScreen()
        }
    }
}
