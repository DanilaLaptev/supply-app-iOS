import Foundation
import SwiftUI
import Combine


struct RejectionItem: RadioGroupItem {
    let id = UUID()
    var name: String
}

class OrderReviewViewModel: ObservableObject {
    private let supplyService: SupplyServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    
    var supplyModel: SupplyModel?
    
    private let branchId = AuthManager.shared.authData?.branchId ?? -1
    
    @Published var rejectionReasonsList = [
        RejectionItem(name: "Недостаточная сумма заказа"),
        RejectionItem(name: "Склад находится слишком далеко от точки питания"),
        RejectionItem(name: "Отсутствуют необходимые товары"),
        RejectionItem(name: "Слишком мало времени на оформление закзаза")
    ]
    
    @Published var selectedRejectionReason: RejectionItem?
    
    init(supplyService: SupplyServiceProtocol = SupplyService()) {
        self.supplyService = supplyService
    }
    
    func setup(_ supply: SupplyModel) {
        supplyModel = supply
    }
    
    func acceptSupply() {
        supplyService.acceptSuppliesGroup(groupId: supplyModel?.id ?? -1, branchId: branchId) { result in
            switch result {
            case .success:
                AlertManager.shared.showAlert(.init(type: .success, description: "Заказ принят!"))
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
    
    func declineSupply() {
        guard selectedRejectionReason != nil else {
            AlertManager.shared.showAlert(.init(type: .error, description: "Вы должны указать причину отказа!"))
            return
        }
        
        supplyService.declineSuppliesGroup(groupId: supplyModel?.id ?? -1, branchId: branchId) { result in
            switch result {
            case .success:
                AlertManager.shared.showAlert(.init(type: .success, description: "Заказ отклонен!"))
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
    
}
