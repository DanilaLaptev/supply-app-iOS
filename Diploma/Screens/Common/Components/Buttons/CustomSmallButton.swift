import SwiftUI

struct CustomSmallButton: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let icon: Image?
    private let background: Color
    private let foregroundColor: Color
    private let onClick: (() -> ())?
    
    init(
        icon: Image? = nil,
        background: Color? = nil,
        foregroundColor: Color? = nil,
        onClick: (() -> ())? = nil
    ) {
        self.icon = icon
        self.background = background ?? Color.customOrange
        self.foregroundColor = foregroundColor ?? Color.customWhite
        self.onClick = onClick
    }
    
    var body: some View {
        Button {
            onClick?()
        } label: {
            icon?
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .padding(6)
                .background(isEnabled ? background : Color.customGray)
                .foregroundColor(isEnabled ? foregroundColor : Color.customBlack)

        }
        .mask(Circle())
        .buttonStyle(PressedButtonStyle())
    }
}

struct CustomSmallButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomSmallButton(icon: .customPlus)
        CustomSmallButton(icon: .customMinus, background: .customWhite, foregroundColor: .customOrange)
    }
}
