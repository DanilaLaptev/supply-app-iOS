import SwiftUI

struct DefaultImageSize: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 24, height: 24)
    }
}

extension Image {
    func defaultImageSize() -> some View {
        modifier(DefaultImageSize())
    }
}
