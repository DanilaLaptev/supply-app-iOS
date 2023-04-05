import Foundation
import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var authManager = AuthManager.shared
    @Published private var viewManager = ViewManager.shared
    @Published private var alertManager = AlertManager.shared

    @Published var nextScreenTag: String? = nil

    @Published var role = OrganizationType.allCases.first!.rawValue
    @Published var email = "1"
    @Published var password = "1"
    
    @Published var tapSignInButton = false
    
    @Published var isValide = false
    
    private var validateFieldsPublisher: AnyPublisher<Result<Void, FormError>, Never> {
        $tapSignInButton
            .dropFirst()
            .map { [weak self] _ in
                guard let self = self else { return .failure(.unknownError(source: "Приложение")) }
                
                if !OrganizationType.allCases.map({ $0.rawValue }).contains(where: { type in
                    type == self.role
                }) {
                    return .failure(.requiredField(source: "Тип организации"))
                }
                
                if self.email.isEmpty {
                    return .failure(.requiredField(source: "Почта"))
                }
                
                if self.password.isEmpty {
                    return .failure(.requiredField(source: "Пароль"))
                }
                
                return .success
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        validateFieldsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] validationResult in
                switch validationResult {
                    
                case .success:
                    self?.isValide = true
                case .failure(let error):
                    let alert = AlertModel(type: .error, description: error.localizedDescription)
                    self?.alertManager.showAlert(alert)
                }
            }
            .store(in: &cancellableSet)
        
        $isValide.dropFirst()
            .filter { $0 }
            .sink { [weak self] _ in
                self?.signInUser()
            }
            .store(in: &cancellableSet)
    }
    
    func signInUser() {
        viewManager.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            
            self.viewManager.isLoading = false

            if self.email == "1" {
                switch self.role {
                case OrganizationType.worker.rawValue:
                    let authData = AuthData(userId: 1, token: "token 1", role: .worker) // TODO: real data
                    self.authManager.setData(authData)
                    self.nextScreenTag = CustomerTabBarWrapper.tag
                    return
                case OrganizationType.supplier.rawValue:
                    let authData = AuthData(userId: 1, token: "token 1", role: .supplier) // TODO: real data
                    self.authManager.setData(authData)
                    self.nextScreenTag = CustomerTabBarWrapper.tag
                    return
                default:
                    self.alertManager.showAlert(AlertModel(type: .error, description: "Неверный тип организации"))
                }
                
                let authData = AuthData(userId: 1, token: "token 1", role: .worker) // TODO: real data
                self.authManager.setData(authData)
                self.nextScreenTag = CustomerTabBarWrapper.tag
                return
            }
                
            self.alertManager.showAlert(AlertModel(type: .error, description: "Пользователь не найден"))
        }
    }
}
