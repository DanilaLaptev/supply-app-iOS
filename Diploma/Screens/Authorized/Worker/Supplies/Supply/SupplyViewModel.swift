import Foundation
import SwiftUI
import Combine


class SupplyViewModel: ObservableObject {
    var updateBindings: UpdateBindingsProtocol?
    private let supplyService: SupplyServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published var supplyModel: SupplyModel?
    
    @Published var disableAcceptButton: Bool = true
    
    private let branchId = AuthManager.shared.authData?.branchId ?? -1
    
    private var disableAcceptButtonPublisher: AnyPublisher<Bool, Never> {
        $supplyModel
            .map { supply in
                supply?.statusHistory.last?.status != .delivered
            }.eraseToAnyPublisher()
    }
    
    init(supplyService: SupplyServiceProtocol = SupplyService()) {
        self.supplyService = supplyService
        setupBindings()
    }
    
    private func setupBindings() {
        disableAcceptButtonPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] disabled in
                self?.disableAcceptButton = disabled
            }.store(in: &cancellableSet)
    }
    
    func acceptSupply() {
        supplyService.acceptSuppliesGroup(groupId: supplyModel?.id ?? -1, branchId: branchId) { [weak self] result in
            switch result {
            case .success:
                AlertManager.shared.showAlert(.init(type: .success, description: "Заказ принят!"))
                self?.supplyModel?.statusHistory.append(SupplyStatusHistory(status: .supplyAccepted, created: Date()))
                self?.updateBindings?.update()
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
    
    func setup(supplyModel: SupplyModel) {
        self.supplyModel = supplyModel
    }
}
