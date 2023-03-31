import Foundation
import SwiftUI

class LoadingScreenViewModel: ObservableObject {
    @Published var nextScreenTag: String? = nil

    func binding() {
        
    }
    
    func checkUserAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nextScreenTag = AuthorizationWrapper.tag
        }
    }
}
