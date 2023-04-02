import SwiftUI

struct CustomTextField: View {
    @Binding var textFieldValue: String
    
    var icon: Image? = nil
    var isDividerVisible: Bool = false
    var placeholder: String
    var background: Color = .clear

    private let divider: some View = Rectangle()
        .foregroundColor(Color.customDarkGray)

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            icon?
                .frame(width: 24, height: 24)
                .foregroundColor(.customOrange)
        
            if isDividerVisible { divider
                .frame(width: 1)
                .frame(maxHeight: .infinity)
            }
            
            TextField(placeholder, text: $textFieldValue)
                .accentColor(.customOrange)
                .foregroundColor(.customBlack)
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .frame(height: 48)
        .background(background.cornerRadius(8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.customDarkGray, lineWidth: 1)
        )
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(textFieldValue: .constant(""), placeholder: "placeholder")
        CustomTextField(textFieldValue: .constant(""), icon: .customRoute, placeholder: "placeholder")
        CustomTextField(textFieldValue: .constant(""), icon: .customSearch, isDividerVisible: true, placeholder: "placeholder")
    }
}
