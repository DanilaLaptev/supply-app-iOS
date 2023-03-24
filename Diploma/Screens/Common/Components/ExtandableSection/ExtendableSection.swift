import SwiftUI

struct ExtendableSection<Content: View, Header: View>: View {
    @State var isCollapsed = true
    let content: Content
    let headerContent: Header
    
    init(
        isCollapsed: Bool = true,
        @ViewBuilder content: () -> Content,
        @ViewBuilder headerContent: () -> Header
    ) {
        self._isCollapsed = .init(initialValue: isCollapsed)
        self.content = content()
        self.headerContent = headerContent()
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ExtendableSectionHeader(isCollapsed: $isCollapsed) {
                headerContent
            }
            
            HStack(alignment: .top) {
                content
            }
            .frame(height: isCollapsed ? 0 : nil)
            .clipped()
        }
        .padding(16)
        .background(Color.customWhite)
        .cornerRadius(8)
    }
}

struct CollapsedSection_Previews: PreviewProvider {
    static var previews: some View {
        ExtendableSection {
            Text("content")
        } headerContent: {
            Text("header")
        }
    }
}
