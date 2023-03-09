import Foundation
import SwiftUI

class ViewTools: ObservableObject {
    @Published var bottomBarIsVisible: Bool = false
    @Published var safeAreaInsets: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
}

extension View {
    func setBottomBarVisibility(_ isVisible: Bool) {
        @EnvironmentObject var viewTools: ViewTools
        
        viewTools.bottomBarIsVisible = isVisible
    }
}
