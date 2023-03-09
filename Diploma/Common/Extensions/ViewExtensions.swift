import SwiftUI

extension View {
    var safeAreaEdgeInsets: EdgeInsets {
        let safeArea = UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return EdgeInsets(top: safeArea.top,
                   leading: safeArea.left,
                   bottom: safeArea.bottom,
                   trailing: safeArea.right)
    }
}
