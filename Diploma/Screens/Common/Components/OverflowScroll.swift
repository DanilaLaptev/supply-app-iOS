import SwiftUI

struct OverflowScroll<Content: View>: View {
    @State private var contentOverflow: Bool = false
    @State private var keyboardHeight: CGFloat = 0

    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { mainGeo in
            content()
                .padding(.bottom, keyboardHeight)
                .background(
                    GeometryReader { contentGeo in
                        Color.clear.onAppear {
                            contentOverflow = contentGeo.size.height > mainGeo.size.height - keyboardHeight
                        }
                    }
                )
                .scrollViewWrapper(contentOverflow)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                        let keyboardHeight = value.height
                        
                        self.keyboardHeight = keyboardHeight
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                        self.keyboardHeight = 0
                    }
                }
        }
    }
}

struct OverflowScroll_Previews: PreviewProvider {
    @State static var text = ""
    static var previews: some View {
        OverflowScroll {
            Rectangle()
                .frame(height: 2400)
                .foregroundColor(.customBlue)
        }
        .defaultScreenSettings()
        
        OverflowScroll {
            Rectangle()
                .frame(height: 2400)
                .foregroundColor(.customBlue)
        }
        .defaultScreenSettings()
        
        OverflowScroll {
            VStack {
                TextField("", text: $text).border(.red)
                Rectangle()
                    .frame(height: 2400)
                    .foregroundColor(.customBlue)

            }
            .padding(.top, 90)
        }
        .defaultScreenSettings()
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
