import Foundation
import SwiftUI
import Moya
import Combine


class LoadingScreenViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()

    @Published var authManager = AuthManager.shared
    
    @Published var navigateToAuthWrapper: Bool = false
    @Published var isLoading = false
    @Published var isIpValid = false
    @Published var ipFieldValue: String = {
        let currentBaseUrl = RequestDefaults.baseUrl().absoluteString
        let start = currentBaseUrl.index(currentBaseUrl.startIndex, offsetBy: 7)
        let end = currentBaseUrl.index(currentBaseUrl.endIndex, offsetBy: -6)
        let range = start..<end

        let ip = String(currentBaseUrl[range])
        return ip
    }()

    private let authProvider = MoyaProvider<AuthorizationProvider>()
    
    private var ipValid: AnyPublisher<Bool, Never> {
        $ipFieldValue
            .map { ip in
                var sin = sockaddr_in()
                return ip.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1
            }.eraseToAnyPublisher()
    }
    
    init() {
        ipValid
            .receive(on: RunLoop.main)
            .sink { [weak self] valid in
                self?.isIpValid = valid
            }.store(in: &cancellableSet)
    }
    
    func setBaseUrl() {
        RequestDefaults.changeBaseUrl(ipFieldValue)
    }
    
    func checkUserAuth() {
        authProvider.request(.check) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    let authorizationDto = try? response.map(AuthorizationDto.self)
                    
                    guard let authorizationDto,
                          let organizationId = authorizationDto.organizationId,
                          let branchId = authorizationDto.mainBranchId,
                          let token = authorizationDto.token,
                          let role = authorizationDto.role else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Не удалось получить данные пользователя"))
                        self?.authManager.setData(nil)
                        self?.navigateToAuthWrapper = true
                        return
                    }
                    
                    let authData = AuthData(organizationId: organizationId, branchId: branchId, token: token, role: role)
                    self?.authManager.setData(authData)
                    self?.navigateToAuthWrapper = true
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
            self?.navigateToAuthWrapper = true
        }
    }
}
