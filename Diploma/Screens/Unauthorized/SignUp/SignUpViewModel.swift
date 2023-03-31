import Foundation
import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var nextScreenTag: String? = nil
    
    
    func checkUserAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nextScreenTag = AuthorizationWrapper.tag
        }
    }
}
