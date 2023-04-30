import Foundation
import SwiftUI
import Combine
import Moya

class ContactViewModel: ObservableObject {
    @Published var fullName = "test test test"
    @Published var email = "test@sfedu.ru"
    @Published var phone = "8 800 555 35 35"
    @Published var navigateToLocationView: Bool = false

    @Published private(set) var organization = OrganizationCreationModel()
    
    private let organizationBranchProvider = MoyaProvider<OrganizationBranchProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var fullNameValidation = ""
    @Published private var emailValidation = ""
    @Published private var phoneValidation = ""

    private var isFullNameValid: AnyPublisher<String, Never> {
        $fullName
            .map { fullName in
                guard !fullName.isEmpty else {
                    return FormError.requiredField(source: "Полное имя").localizedDescription
                }
                return ""
            }.eraseToAnyPublisher()
    }
    
    private var isEmailValid: AnyPublisher<String, Never> {
        $email
            .map { email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                guard emailPredicate.evaluate(with: email) else {
                    return FormError.wrongFormat(source: "Почта").localizedDescription
                }
                return ""
            }.eraseToAnyPublisher()
    }
    
    private var isPhoneValid: AnyPublisher<String, Never> {
        $phone
            .map { phone in
                guard !phone.isEmpty else {
                    return FormError.requiredField(source: "Телефон").localizedDescription
                }
                return ""
            }.eraseToAnyPublisher()
    }
    
    init() {
        isFullNameValid
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.fullNameValidation = error
            }.store(in: &cancellableSet)
        
        isEmailValid
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.emailValidation = error
            }.store(in: &cancellableSet)
        
        isPhoneValid
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.phoneValidation = error
            }.store(in: &cancellableSet)
    }
    
    
    private func validateForm() -> Bool {
        guard fullNameValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: fullNameValidation))
            return false
        }

        guard emailValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: emailValidation))
            return false
        }

        guard phoneValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: phoneValidation))
            return false
        }

        return true
    }
    
    func createOrganizationBranch() {
        guard validateForm() else { return }
        
        let branchDto = OrganizationBranchDto(
            contactPersons: []
        )
        
        guard let organizationId = organization.organizationId else {
            return
        }
            
        organizationBranchProvider.request(.createOrganizationBranch(
            branch: branchDto
        )) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let response = try? response.map(OrganizationBranchDto.self) else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))

                        return
                    }
                    self?.organization.organizationBranchId = response.id
                    self?.addOrganiztionContactPerson()
                } else {
                    let errorDto = try? response.map(ErrorDto.self)
                    AlertManager.shared.showAlert(.init(type: .error, description: errorDto?.message ?? "Произошла ошибка"))
                }
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
        
        addOrganiztionContactPerson()
    }
    
    private func addOrganiztionContactPerson() {
        let requestBody = ContactPersonDto(
            fullName: fullName,
            email: email,
            phone: phone
        )
        
        guard let branchId = organization.organizationBranchId else {
            return
        }
        
        organizationBranchProvider.request(.addContactPerson(
            branchId: branchId,
            contactPerson: requestBody)
        ) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    self?.navigateToLocationView.toggle()
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
    
    func setupOrganization(_ organization: OrganizationCreationModel) {
        self.organization = organization
    }
}
