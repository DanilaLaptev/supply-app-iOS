import Foundation
import SwiftUI
import Moya
import Combine

class MainSignUpViewModel: ObservableObject {
    @Published var navigateToContactView: Bool = false
    
    @Published var role = OrganizationType.allCases.first!.rawValue
    @Published var organizationName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var repeatedPassword = ""
    
    private let authProvider = MoyaProvider<AuthorizationProvider>(plugins: [NetworkLoggerPlugin()])
    
    private var isOrganizationNameValid: AnyPublisher<Bool, Never> {
        $organizationName
            .map { organizationName in
                organizationName.count > 3
            }.eraseToAnyPublisher()
    }
    
    private var isOrganizationEmailValid: AnyPublisher<Bool, Never> {
        $email
            .map { email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }.eraseToAnyPublisher()
    }
    
    private var isPasswordValid: AnyPublisher<Bool, Never> {
        $password
            .map { password in
                password.count > 6
            }.eraseToAnyPublisher()
    }
    
    private var isPasswordsMatchingValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            $password,
            $repeatedPassword
        )
        .map { password, repeatedPassword in
            password == repeatedPassword
        }.eraseToAnyPublisher()
    }
    
    private var isSignUpFormValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(
            isOrganizationNameValid,
            isOrganizationEmailValid,
            isPasswordValid,
            isPasswordsMatchingValid
        )
        .map { nameValid, emailValid, passwordValid, passwordsMatchingValid in
            return nameValid && emailValid && passwordValid && passwordsMatchingValid
        }.eraseToAnyPublisher()
    }
    
    func signUpOrganization() {
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
                    let authorizationDto = try? response.map(AuthorizationDto.self)
                    
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
