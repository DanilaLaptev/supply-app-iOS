import Foundation
import SwiftUI

protocol LoadingScreenViewModelProtocol {
    func checkUserAuth()
}

class LoadingScreenViewModel: ObservableObject, LoadingScreenViewModelProtocol {
    @Published var nextScreenTag: String? = nil

    func binding() {
        
    }
    
    func checkUserAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nextScreenTag = AuthorizationWrapper.tag
        }
    }
}
