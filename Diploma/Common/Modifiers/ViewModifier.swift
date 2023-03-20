import SwiftUI

struct DefaultScreenModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    func defaultScreenSettings() -> some View {
        modifier(DefaultScreenModifier())
    }
}
