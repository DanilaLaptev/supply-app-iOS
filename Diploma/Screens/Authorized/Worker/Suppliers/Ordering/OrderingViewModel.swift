import Foundation
import SwiftUI
import Combine

class OrderingViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    var organizationModel: OrganizationModel
    
    var totalPrice: Double {
        organizationModel.storageItems
            .map { $0.price * Double($0.quantity) }
            .reduce(0, +)
    }
    
    init(organizationModel: OrganizationModel) {
        self.organizationModel = organizationModel
    }
    
}
