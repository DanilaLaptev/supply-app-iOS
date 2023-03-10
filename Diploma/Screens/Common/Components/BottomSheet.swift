import SwiftUI

struct BottomSheet<Content: View>: View {
    let enableSafeAreaBottomInset: Bool
    let content: Content
    
    init(
        enableSafeAreaBottomInset: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.enableSafeAreaBottomInset = enableSafeAreaBottomInset
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.bottom, enableSafeAreaBottomInset ? safeAreaEdgeInsets.bottom : 0)
            .padding(.all, 16)
            .background(Color.customWhite)
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
