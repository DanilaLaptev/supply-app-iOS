import Foundation
import SwiftUI

final class ViewManager: ObservableObject {
    static let shared = ViewManager()
    private init() { }
    
    @Published var bottomBarIsVisible: Bool = false
    @Published var isLoading: Bool = false

}
