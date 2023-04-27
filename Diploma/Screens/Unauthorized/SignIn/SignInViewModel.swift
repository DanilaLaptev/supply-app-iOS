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
    @Published var email = "test@sfedu.ru"
    @Published var password = "aasaaaa"
    
    @Published var isValide = false
    
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
    
    private var isSignInFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            isUserEmailValid,
            isPasswordValidPublisher
        )
        .map { emailValid, passwordValid in
            return emailValid && passwordValid
        }.eraseToAnyPublisher()
    }
    
    init() {
        isSignInFormValidPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] validationResult in
                self?.isValide = true
            }
            .store(in: &cancellableSet)
    }
    
    func signInOrganization() {
        let requestBody = AuthorizationDto(role: role == "Сбыт" ? "WORKER" : "SUPPLIER", email: email, password: password)
        authProvider.request(.login(requestBody)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    let authorizationDto = try? response.map(AuthorizationDto.self)
                    
                    guard let authorizationDto,
                          let userId = authorizationDto.id,
                          let token = authorizationDto.token,
                          let role: OrganizationType = authorizationDto.role == "worker" ? .worker : .supplier else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Не удалось получить данные пользователя"))
                        self?.authManager.setData(nil)
                        return
                    }
                    
                    let authData = AuthData(userId: userId, token: token, role: role)
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
