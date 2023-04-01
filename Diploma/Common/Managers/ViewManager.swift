import Foundation
import SwiftUI

final class ViewManager: ObservableObject {
    static let shared = ViewManager()
    private init() { }
    
    @Published private(set) var bottomBarIsVisible: Bool = false

    func setBottomBarVisibility(_ isVisible: Bool) {
        bottomBarIsVisible = isVisible
    }
}

