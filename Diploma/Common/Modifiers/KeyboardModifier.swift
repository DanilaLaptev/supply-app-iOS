import Foundation
import SwiftUI

struct KeyboardModifier: ViewModifier {
    @State var contentOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(y: -contentOffset)
            .animation(.linear)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let keyboardHeight = value.height
                    
                    contentOffset = keyboardHeight
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                    contentOffset = 0
                }
            }
    }
}

extension View {
    func keyboardModifier() -> some View {
        modifier(KeyboardModifier())
    }
}
