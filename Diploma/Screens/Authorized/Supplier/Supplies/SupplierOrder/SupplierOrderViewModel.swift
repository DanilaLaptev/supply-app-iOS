import Foundation
import SwiftUI
import Combine


class SupplierOrderViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published var supplyModel: SupplyModel?
    
    @Published var disableAcceptButton: Bool = true
    
    private var disableAcceptButtonPublisher: AnyPublisher<Bool, Never> {
        $supplyModel
            .map { supply in
                supply?.statusHistory.contains(where: { $0.status == .denied || $0.status == .approved }) ?? true
            }.eraseToAnyPublisher()
    }
    
    init() {
        disableAcceptButtonPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] disabled in
                self?.disableAcceptButton = disabled
            }.store(in: &cancellableSet)
    }
    
    func setup(supplyModel: SupplyModel) {
        self.supplyModel = supplyModel
    }
}
