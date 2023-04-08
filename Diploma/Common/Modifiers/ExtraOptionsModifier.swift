import SwiftUI

struct ExtraOption: Identifiable {
    let id = UUID()
    var icon: Image = .customRoute
    var action: (() -> ())? = nil
    
    init(icon: Image, action: (() -> Void)? = nil) {
        self.icon = icon
        self.action = action
    }
}

struct ExtraOptionsModifier: ViewModifier {
    @State private var showExtraOptions = false

    let options: [ExtraOption]
    
    init(options: [ExtraOption]) {
        self.options = options
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.trailing , 40)
            .overlay(
                HStack {
                    Spacer()

                    HStack(spacing: 8) {
                        CustomButton(icon: .customExtra, background: .clear, foreground: .customOrange) {
                            withAnimation {
                                showExtraOptions.toggle()
                            }
                        }
                        .frame(width: 24, height: 24)
                        
                        HStack(spacing: 8) {
                            ForEach(options) { option in
                                CustomButton(icon: option.icon, background: .customOrange, foreground: .customWhite, isCircleShape: true) {
                                    showExtraOptions.toggle()
                                    option.action?()
                                }
                                .frame(width: 48, height: 48)
                            }
                        }
                    }
                    .padding(.vertical, 32)
                    .padding(.horizontal, 8)
                    .frame(maxHeight: .infinity)
                    .background(Color.customLightOrange)
                    .offset(x: showExtraOptions ? 0 : CGFloat(56 * options.count))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .clipped()
            .animation(.linear, value: showExtraOptions)
    }
}

extension View {
    func extraOptions(_ options: [ExtraOption]) -> some View {
        modifier(ExtraOptionsModifier(options: options))
    }
}
