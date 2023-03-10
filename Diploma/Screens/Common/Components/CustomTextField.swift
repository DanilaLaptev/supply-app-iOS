import SwiftUI

struct CustomTextField: View {
    @State private var textFieldValue = ""
    
    private let icon: Image?
    private let isDividerVisible: Bool
    private let placeholder: String

    private let divider: some View = Rectangle()
        .foregroundColor(Color.customDarkGray)
    
    init(
        icon: Image? = nil,
        isDividerVisible: Bool? = nil,
        placeholder: String
    ) {
        self.icon = icon
        self.isDividerVisible = isDividerVisible ?? false
        self.placeholder = placeholder
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            icon?
                .frame(width: 24, height: 24)
                .foregroundColor(.customOrange)
        
            if isDividerVisible { divider
                .frame(width: 1, height: .infinity)
            }
            
            TextField(placeholder, text: $textFieldValue)
                .accentColor(.customOrange)
                .foregroundColor(.customBlack)
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .frame(height: 48)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.customDarkGray, lineWidth: 1)
        )
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeholder: "placeholder")
        CustomTextField(icon: .customRoute, placeholder: "placeholder")
        CustomTextField(icon: .customSearch, isDividerVisible: true, placeholder: "placeholder")
    }
}
