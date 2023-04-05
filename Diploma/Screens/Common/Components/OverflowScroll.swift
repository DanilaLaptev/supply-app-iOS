import SwiftUI

struct OverflowScroll<Content: View>: View {
    @State private var contentOverflow: Bool = false
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { mainGeo in
            content()
                .background(
                    GeometryReader { contentGeo in
                        Color.clear.onAppear {
                            contentOverflow = contentGeo.size.height > mainGeo.size.height
                        }
                    }
                )
                .keyboardModifier()
                .scrollViewWrapper(contentOverflow)
        }
    }
}

struct OverflowScroll_Previews: PreviewProvider {
    static var previews: some View {
        OverflowScroll {
            Rectangle()
                .frame(height: 2400)
                .foregroundColor(.customBlue)
        }
        .defaultScreenSettings()
        OverflowScroll {}
    }
}

extension View {
    @ViewBuilder
    func scrollViewWrapper(_ contentOverflow: Bool) -> some View {
        if contentOverflow {
            ScrollView { self }
            .onAppear { UIScrollView.appearance().bounces = false }
            .onDisappear { UIScrollView.appearance().bounces = true }
        } else { self }
    }
}
