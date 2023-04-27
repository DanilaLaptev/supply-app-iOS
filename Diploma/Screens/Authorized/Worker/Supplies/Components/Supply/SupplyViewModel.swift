import Foundation
import SwiftUI
import Combine

class SupplyViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published var supplyModel: SupplyModel?
    
    @Published var disableAcceptButton: Bool = true
    
    private var disableAcceptButtonPublisher: AnyPublisher<Bool, Never> {
        $supplyModel
            .map { supply in
                if case .inProgress = supply?.statusHistory.first?.status {
                    return false
                }
                return true
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
