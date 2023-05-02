import Foundation
import SwiftUI
import Combine

class OrderingViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    var organizationModel: OrganizationBranchModel?
    var selectedItems: [StorageItemWrapper]?
    @Published var date = Date()
    
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
    
    func setup(organizationModel: OrganizationBranchModel, selectedItems: [StorageItemWrapper]) {
        self.organizationModel = organizationModel
        self.selectedItems = selectedItems
    }
}
