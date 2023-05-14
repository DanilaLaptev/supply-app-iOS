import Foundation
import SwiftUI
import Combine


class OrderingViewModel: ObservableObject {
    var navigation: NavigationProtocol?
    private let supplyService: SupplyServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    
    var organizationModel: OrganizationModel?
    var selectedItems: [StorageItemWrapper]?
    @Published var deliveryDate = Date()
    
    var totalPrice: Double {
        selectedItems?
            .map { $0.item.price * Double($0.selectedAmmount) }
            .reduce(0, +) ?? 0
    }
    
    var selectedProductsNumber: Int {
        selectedItems?
            .map { $0.selectedAmmount }
            .reduce(0, +) ?? 0
    }
    
    init(supplyService: SupplyServiceProtocol = SupplyService()) {
        self.supplyService = supplyService
    }
    
    func setup(organizationModel: OrganizationModel, selectedItems: [StorageItemWrapper]) {
        self.organizationModel = organizationModel
        self.selectedItems = selectedItems
    }
    
    func createSupply() {
        guard let selectedItems else { return }
        
        let storageItems = selectedItems.map { wrappedItem in
            StorageItemDto(id: wrappedItem.item.id, quantity: wrappedItem.selectedAmmount)
        }
        
        let supplyDto = SupplyDto(
            fromBranch: organizationModel?.mainBranch?.id,
            toBranch: AuthManager.shared.authData?.branchId,
            deliveryTime: deliveryDate.toString(),
            items: storageItems
        )
        
        supplyService.createSupply(supply: supplyDto) { [weak self] result in
            switch result {
            case .success:
                AlertManager.shared.showAlert(.init(type: .success, description: "Заказ оформлен"))
                self?.navigation?.back()
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
}
