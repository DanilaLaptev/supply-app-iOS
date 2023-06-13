import Foundation
import SwiftUI
import Combine


class LoadingScreenViewModel: ObservableObject {
    private let authorizationService: AuthorizationServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published var authManager = AuthManager.shared
    
    @Published var navigateToAuthWrapper: Bool = false
    @Published var isLoading = false
    @Published var ipFieldValue: String = "localhost"
        
    
    init(authorizationService: AuthorizationServiceProtocol = AuthorizationService()) {
        self.authorizationService = authorizationService
    }

    func setBaseUrl() {
        RequestDefaults.changeBaseUrl(ipFieldValue)
    }
    
    func checkUserAuth() {
        authorizationService.check { [weak self] result in
            switch result {
            case .success(let authorizationDto):
                guard let organizationId = authorizationDto.organizationId,
                      let branchId = authorizationDto.mainBranchId,
                      let role = authorizationDto.role else {
                    AlertManager.shared.showAlert(.init(type: .error, description: "Не удалось получить данные пользователя"))
                    self?.authManager.setData(nil)
                    self?.navigateToAuthWrapper = true
                    return
                }
                
                let authData = AuthData(
                    organizationId: organizationId,
                    branchId: branchId,
                    token: KeychainManager.shared.get(.accessToken) ?? "none",
                    role: role
                )
                self?.authManager.setData(authData)
                self?.navigateToAuthWrapper = true
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
                self?.authManager.setData(nil)
            }
            self?.navigateToAuthWrapper = true
        }
    }
}
