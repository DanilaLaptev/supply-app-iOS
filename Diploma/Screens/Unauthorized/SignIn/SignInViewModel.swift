import Foundation
import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var authManager = AuthManager.shared
    @Published private var viewManager = ViewManager.shared
    @Published private var alertManager = AlertManager.shared

    @Published var nextScreenTag: String? = nil

    @Published var email = "1"
    @Published var password = "1"
    
    private func validateSignInData() -> Result<Void, FormError> {
        if email.isEmpty {
            return .failure(.requiredField(source: "Почта"))
        }
        
        if password.isEmpty {
            return .failure(.requiredField(source: "Пароль"))
        }
        
        return .success
    }
    
    func signInUser() {
        let validationResult = validateSignInData()
        
        switch validationResult {
            
        case .success:
            signInRequest()
        case .failure(let error):
            let alert = AlertModel(type: .error, description: error.localizedDescription)
            alertManager.showAlert(alert)
        }
    }
    
    private func signInRequest() {
        viewManager.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            if self?.email == "1" {
                let authData = AuthData(userId: 1, token: "token 1", role: .worker) // TODO: real data
                self?.authManager.setData(authData)
                self?.nextScreenTag = CustomerTabBarWrapper.tag
            }
            
            if self?.email == "1a" {
                let authData = AuthData(userId: 2, token: "token 2", role: .supplier) // TODO: real data
                self?.authManager.setData(authData)
                self?.nextScreenTag = SupplierTabBarWrapper.tag
            } else {
                self?.alertManager.showAlert(AlertModel(type: .error, description: "Пользователь не найден"))
            }
            
            self?.viewManager.isLoading = false
        }
    }
}
