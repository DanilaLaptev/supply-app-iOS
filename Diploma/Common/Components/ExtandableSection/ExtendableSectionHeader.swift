import SwiftUI

struct ExtendableSectionHeader<Content: View>: View {
    @Binding var isCollapsed: Bool
    let content: Content

    init(
        isCollapsed: Binding<Bool>,
        @ViewBuilder _ content: () -> Content
    ) {
        self._isCollapsed = isCollapsed
        self.content = content()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            content
            Spacer()
            CustomSmallButton(icon: .customBackShort, background: .clear, foregroundColor: .customOrange) {
                isCollapsed.toggle()
            }
            .rotationEffect(.degrees(isCollapsed ? 180 : 270))
            .animation(.easeInOut)
        }
    }
}

struct ExtandableSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        ExtendableSectionHeader(isCollapsed: .constant(true)) {
            Text("test")
        }
    }
}
