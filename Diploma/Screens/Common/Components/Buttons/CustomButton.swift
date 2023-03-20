import SwiftUI

struct CustomButton: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var icon: Image? = nil
    var label: Text? = nil

    var background: Color = .customOrange
    var foreground: Color = .customWhite
    var isCircleShape: Bool = false
    var onClick: (() -> ())? = nil

    var body: some View {
        Button {
            onClick?()
        } label: {
            HStack(alignment: .center ,spacing: 8) {
                icon?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                label?.font(.customStandard)
            }
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing], 16)
            .background(isEnabled ? background : Color.customGray)
            .foregroundColor(isEnabled ? foreground : Color.customBlack)
        }
        .mask(isCircleShape ? AnyView(Circle()) : AnyView(RoundedRectangle(cornerRadius: 8)))
        .buttonStyle(PressedButtonStyle())
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(icon: .customPlus).frame(width: 48)
        CustomButton(icon: .customPlus, isCircleShape: true)
        CustomButton(icon: .customPlus, label: Text("Plus"))
        CustomButton(label: Text("Plus"))
        CustomButton(icon: .customBox, label: Text("Plus")).disabled(true)
    }
}
