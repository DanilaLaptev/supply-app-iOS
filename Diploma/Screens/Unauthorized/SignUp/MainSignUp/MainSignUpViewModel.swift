import Foundation
import SwiftUI
import Moya
import Combine

class MainSignUpViewModel: ObservableObject {
    @Published var navigateToContactView: Bool = false
    @Published var role = OrganizationType.allCases.first!.rawValue
    @Published var organizationName = "Test name"
    @Published var email = "test@sfedu.ru"
    @Published var password = "qqqqqq"
    @Published var repeatedPassword = "qqqqqq"

    @Published private(set) var organization = OrganizationCreationModel()
    
    @Published private var orgniazationNameValidation = ""
    @Published private var orgniazationEmailValidation = ""
    @Published private var passwordValidation = ""
    @Published private var passwordMatchingValidation = ""

    
    private let authProvider = MoyaProvider<AuthorizationProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    
    private var isOrganizationNameValid: AnyPublisher<String, Never> {
        $organizationName
            .map { organizationName in
                guard organizationName.count > 3 else {
                    return FormError.minimumCharactersNumber(source: "Название организации", 3).localizedDescription
                }
                return ""
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
    
    private var isPasswordsMatchingValid: AnyPublisher<String, Never> {
        Publishers.CombineLatest(
            $password,
            $repeatedPassword
        )
        .map { password, repeatedPassword in
            guard password == repeatedPassword else {
                return FormError.customError(source: "Пароль", description: "Пароли не совпадают").localizedDescription
            }
            return ""
        }.eraseToAnyPublisher()
    }

    init() {
        isOrganizationNameValid
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.orgniazationNameValidation = error
            }.store(in: &cancellableSet)
        
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
        
        isPasswordsMatchingValid
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.passwordMatchingValidation = error
            }.store(in: &cancellableSet)
    }
    
    private func validateForm() -> Bool {
        guard orgniazationNameValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: orgniazationNameValidation))
            return false
        }
        
        guard orgniazationEmailValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: orgniazationEmailValidation))
            return false
        }
        
        guard passwordValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: passwordValidation))
            return false
        }
        
        guard passwordMatchingValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: passwordMatchingValidation))
            return false
        }
        
        return true
    }
    
    func signUpOrganization() {
        guard validateForm() else { return }
        
        let requestBody = AuthorizationDto(
            role: role == "Сбыт" ? "WORKER" : "SUPPLIER",
            title: organizationName,
            email: email,
            password: password
        )
        
        authProvider.request(.register(requestBody)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let response = try? response.map(AuthorizationDto.self) else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                        return
                    }
                    KeychainManager.shared.save(response.token, key: .accessToken)
                    self?.organization.organizationId = response.id
                    self?.navigateToContactView.toggle()
                } else {
                    let errorDto = try? response.map(ErrorDto.self)
                    AlertManager.shared.showAlert(.init(type: .error, description: errorDto?.message ?? "Произошла ошибка"))
                }
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
}
