import Foundation
import SwiftUI
import Combine
import Moya

class SignInViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var authManager = AuthManager.shared
    @Published private var viewManager = ViewManager.shared
    @Published private var alertManager = AlertManager.shared

    @Published var navigateToSupplierMain: Bool = false
    @Published var navigateToWorkerMain: Bool = false
    @Published var navigateToSignUp: Bool = false

    private let authProvider = MoyaProvider<AuthorizationProvider>(plugins: [NetworkLoggerPlugin()])
    
    @Published var role = OrganizationType.allCases.first!.rawValue
    @Published var email = "dlaptev@yandex.ru"
    @Published var password = "QWERTY"
    
    @Published private var orgniazationEmailValidation = ""
    @Published private var passwordValidation = ""

    private var isUserEmailValid: AnyPublisher<Bool, Never> {
        $email
            .map { email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }.eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { password in
                password.count > 3
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
    
    init() {
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
        
        let requestBody = AuthorizationDto(role: role == "Сбыт" ?.worker : .supplier, email: email, password: password)
        authProvider.request(.login(requestBody)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    let authorizationDto = try? response.map(AuthorizationDto.self)
                    
                    guard let authorizationDto,
                          let organizationId = authorizationDto.organizationId,
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
                } else {
                    let errorDto = try? response.map(ErrorDto.self)
                    AlertManager.shared.showAlert(.init(type: .error, description: errorDto?.message ?? "Произошла ошибка"))
                    self?.authManager.setData(nil)
                }
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
                self?.authManager.setData(nil)
            }
        }
    }
}
