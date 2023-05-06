import Foundation
import SwiftUI
import Combine
import Moya

class ProfileViewModel: ObservableObject {
    private let organizationProvider = MoyaProvider<OrganizationProvider>(plugins: [NetworkLoggerPlugin(), NetworkCacheablePlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private(set) var organizationInfo: OrganizationModel?
    
    init() {
        fetchOrganizationData()
    }
    
    func fetchOrganizationData() {
        organizationProvider.request(.getOrganization(id: AuthManager.shared.authData?.organizationId ?? -1)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let self,
                          let response = try? response.map(OrganizationDto.self) else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                        return
                    }
                    
                    self.organizationInfo = OrganizationModel.from(response)
                    
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
