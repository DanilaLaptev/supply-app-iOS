import Foundation
import SwiftUI
import Combine
import Moya


class SupplyViewModel: ObservableObject {
    private let supplyProvider = MoyaProvider<SupplyProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published var supplyModel: SupplyModel?
    
    @Published var disableAcceptButton: Bool = true
    
    private var disableAcceptButtonPublisher: AnyPublisher<Bool, Never> {
        $supplyModel
            .map { supply in
                supply?.statusHistory.filter { $0.status == .delivered || $0.status == .supplyAccepted }.isEmpty ?? true
            }.eraseToAnyPublisher()
    }
    
    init() {
        disableAcceptButtonPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] disabled in
                self?.disableAcceptButton = disabled
            }.store(in: &cancellableSet)
    }
    
    func acceptSupply() {
        supplyProvider.request(.acceptSuppliesGroup(groupId: supplyModel?.id ?? -1, branchId: AuthManager.shared.authData?.branchId ?? -1)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    AlertManager.shared.showAlert(.init(type: .success, description: "Заказ принят!"))
                    // TODO: back to pervious screen
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
    
    func setup(supplyModel: SupplyModel) {
        self.supplyModel = supplyModel
    }
}
