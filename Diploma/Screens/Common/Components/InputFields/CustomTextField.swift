import SwiftUI

struct CustomTextField: View {
    @Binding var textFieldValue: String
    @State private var contentVisible = false
    
    var icon: Image? = nil
    var isDividerVisible: Bool = false
    var placeholder: String
    var background: Color = .clear
    var isSecure = false
    
    private let divider: some View = Rectangle()
        .foregroundColor(Color.customDarkGray)

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            icon?
                .frame(width: 24, height: 24)
                .foregroundColor(.customOrange)
        
            if isDividerVisible {
                divider
                .frame(width: 1)
                .frame(maxHeight: .infinity)
            }

            CustomTextField()
                .accentColor(.customOrange)
                .foregroundColor(.customBlack)
                .font(.customStandard)
            
            if isSecure {
                Button {
                    contentVisible.toggle()
                } label: {
                    EyeIcon()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.customOrange)
                }
                .animation(.linear(duration: 0))
            }
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
    
    @ViewBuilder
    func CustomTextField() -> some View {
        if isSecure, !contentVisible {
            SecureField(placeholder, text: $textFieldValue)
        } else {
            TextField(placeholder, text: $textFieldValue)
        }
    }
    
    @ViewBuilder
    func EyeIcon() -> some View {
        if contentVisible {
            Image.customEye
        } else {
            Image.customClosedEye
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    @State static var text = ""
    static var previews: some View {
        CustomTextField(textFieldValue: $text, placeholder: "placeholder")
        CustomTextField(textFieldValue: $text, icon: .customRoute, placeholder: "placeholder")
        CustomTextField(textFieldValue: $text, icon: .customSearch, isDividerVisible: true, placeholder: "placeholder")
    }
}
