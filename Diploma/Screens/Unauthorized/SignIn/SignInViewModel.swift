import Foundation
import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var authManager = AuthManager.shared
    @Published private var viewManager = ViewManager.shared
    @Published private var alertManager = AlertManager.shared
    
    @Published var navigateToSupplierMain: Bool = false
    @Published var navigateToWorkerMain: Bool = false
    @Published var navigateToSignUp: Bool = false
    
    private let authorizationService: AuthorizationServiceProtocol
    
    @Published var email = "supplier@email.com"
    @Published var password = "123123"
    
    @Published private var orgniazationEmailValidation = ""
    @Published private var passwordValidation = ""
    
    private var isUserEmailValid: AnyPublisher<Bool, Never> {
        $email
            .map { email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }.eraseToAnyPublisher()
    }
    
    private var isOrganizationEmailValid: AnyPublisher<String, Never> {
        $email
            .map { email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                guard emailPredicate.evaluate(with: email) else {
                    return FormError.wrongFormat(source: "Почта").localizedDescription
                }
                return ""
            }.eraseToAnyPublisher()
    }
    
    private var isPasswordValid: AnyPublisher<String, Never> {
        $password
            .map { password in
                guard password.count > 5 else {
                    return FormError.minimumCharactersNumber(source: "Пароль", 5).localizedDescription
                }
                return ""
            }.eraseToAnyPublisher()
    }
    
    init(authorizationService: AuthorizationServiceProtocol = AuthorizationService()) {
        self.authorizationService = authorizationService
        setupBindings()
    }
    
    private func setupBindings() {
        isOrganizationEmailValid
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.orgniazationEmailValidation = error
            }.store(in: &cancellableSet)
        
        isPasswordValid
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.passwordValidation = error
            }.store(in: &cancellableSet)
    }
    
    private func validateForm() -> Bool {
        guard orgniazationEmailValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: orgniazationEmailValidation))
            return false
        }
        
        guard passwordValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: passwordValidation))
            return false
        }
        
        return true
    }
    
    func signInOrganization() {
        guard validateForm() else { return }
        
        let requestBody = AuthorizationDto(email: email, password: password)
        authorizationService.login(requestBody) { [weak self] result in
            switch result {
            case .success(let authorizationDto):
                guard let organizationId = authorizationDto.organizationId,
                      let branchId = authorizationDto.mainBranchId,
                      let token = authorizationDto.token,
                      let role: OrganizationType = authorizationDto.role  else {
                    AlertManager.shared.showAlert(.init(type: .error, description: "Не удалось получить данные пользователя"))
                    self?.authManager.setData(nil)
                    return
                }
                
                let authData = AuthData(organizationId: organizationId, branchId: branchId, token: token, role: role)
                KeychainManager.shared.save(token, key: .accessToken)
                self?.authManager.setData(authData)
                
                if case .supplier = role {
                    self?.navigateToSupplierMain.toggle()
                } else {
                    self?.navigateToWorkerMain.toggle()
                }
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
                self?.authManager.setData(nil)
            }
        }
    }
}
