import Foundation
import SwiftUI

class MainSignUpViewModel: ObservableObject {
    @Published var nextScreenTag: String? = nil
    
    @Published var role = OrganizationType.allCases.first!.rawValue
    @Published var organizationName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var repeatedPassword = ""

    func checkUserAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nextScreenTag = AuthorizationWrapper.tag
        }
    }
}
