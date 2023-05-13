import Foundation
import SwiftUI
import Combine


class ProfileViewModel: ObservableObject {
    private let organizationService: OrganizationServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private(set) var organizationInfo: OrganizationModel?
    
    init(organizationService: OrganizationServiceProtocol = OrganizationService()) {
        self.organizationService = organizationService
        fetchOrganizationData()
    }
    
    func fetchOrganizationData() {
        let organizationId = AuthManager.shared.authData?.organizationId ?? -1
        
        organizationService.getOrganization(id: organizationId) { [weak self] result in
            switch result {
            case .success(let response):
                self?.organizationInfo = OrganizationModel.from(response)
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
}
