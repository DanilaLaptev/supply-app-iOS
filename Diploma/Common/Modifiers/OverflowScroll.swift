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
                .scrollViewWrapper(contentOverflow)
        }
        
    }
}

struct OverflowScroll_Previews: PreviewProvider {
    static var previews: some View {
        OverflowScroll {}
    }
}

extension View {
    @ViewBuilder
    func scrollViewWrapper(_ contentOverflow: Bool) -> some View {
        if contentOverflow {
            ScrollView { self }
        } else { self }
    }
}
