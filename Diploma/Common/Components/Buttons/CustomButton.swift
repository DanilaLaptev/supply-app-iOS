import SwiftUI

struct CustomButton: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let isCircleShape: Bool
    private let icon: Image?
    private let label: Text?
    private let onClick: (() -> ())?
    
    init(
        icon: Image? = nil,
        label: Text? = nil,
        isCircleShape: Bool = false,
        onClick: (() -> ())? = nil
    ) {
        self.icon = icon
        self.label = label
        self.isCircleShape = isCircleShape
        self.onClick = onClick
    }
    
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
            .padding([.leading, .trailing], 16)
            .background(isEnabled ? Color.customOrange : Color.customGray)
            .foregroundColor(isEnabled ? Color.customWhite : Color.customBlack)
        }
        .mask(isCircleShape ? AnyView(Circle()) : AnyView(RoundedRectangle(cornerRadius: 8)))
        .buttonStyle(PressedButtonStyle())
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(icon: .customPlus)
        CustomButton(icon: .customPlus, isCircleShape: true)
        CustomButton(icon: .customPlus, label: Text("Plus"))
        CustomButton(label: Text("Plus"))
        CustomButton(icon: .customBox, label: Text("Plus")).disabled(true)
    }
}
