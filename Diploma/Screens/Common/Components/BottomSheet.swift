import SwiftUI

struct BottomSheet<Content: View>: View {
    let enableSafeAreaBottomInset: Bool
    let background: Color
    let content: Content
    
    init(
        enableSafeAreaBottomInset: Bool = true,
        background: Color = .customWhite,
        @ViewBuilder content: () -> Content
    ) {
        self.enableSafeAreaBottomInset = enableSafeAreaBottomInset
        self.background = background
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.bottom, enableSafeAreaBottomInset ? safeAreaEdgeInsets.bottom : 0)
            .padding(.all, 16)
            .background(background)
            .cornerRadius(8, corners: [.topLeft, .topRight])
            .topShadow()
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet {
            Text("aboba")
        }
    }
}
