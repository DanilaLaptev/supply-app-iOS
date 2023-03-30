import Foundation
import SwiftUI

protocol SignUpViewModelProtocol {
    func checkUserAuth()
}

class SignUpViewModel: ObservableObject, LoadingScreenViewModelProtocol {
    @Published var nextScreenTag: String? = nil
    
    
    func checkUserAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nextScreenTag = AuthorizationWrapper.tag
        }
    }
}
