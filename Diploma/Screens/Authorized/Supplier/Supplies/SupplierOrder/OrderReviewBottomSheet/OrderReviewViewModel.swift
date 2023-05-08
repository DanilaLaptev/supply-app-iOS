import Foundation
import SwiftUI
import Combine
import Moya


struct RejectionItem: RadioGroupItem {
    let id = UUID()
    var name: String
}

class OrderReviewViewModel: ObservableObject {
    private let supplyProvider = MoyaProvider<SupplyProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    
    var supplyModel: SupplyModel?
    
    @Published var rejectionReasonsList = [
        RejectionItem(name: "Недостаточная сумма заказа"),
        RejectionItem(name: "Склад находится слишком далеко от точки питания"),
        RejectionItem(name: "Отсутствуют необходимые товары"),
        RejectionItem(name: "Слишком мало времени на оформление закзаза")
    ]
    
    @Published var selectedRejectionReason: RejectionItem?
    
    init() {
        
    }    
    
    func setup(_ supply: SupplyModel) {
        supplyModel = supply
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
    
    func declineSupply() {
        guard let selectedRejectionReason else {
            AlertManager.shared.showAlert(.init(type: .error, description: "Вы должны указать причину отказа!"))
            return
        }
        
        
        supplyProvider.request(.declineSuppliesGroup(groupId: supplyModel?.id ?? -1, branchId: AuthManager.shared.authData?.branchId ?? -1)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    AlertManager.shared.showAlert(.init(type: .success, description: "Заказ отклонен!"))
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
    
}
