import Foundation
import SwiftUI
import Combine


class SupplierOrdersViewModel: ObservableObject {
    private let supplyService: SupplyServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    
    @Published var supplyStatuses: [SupplyStatus] = []
    
    var dateRangeTitle: String {
        guard let startDate, let endDate else { return "Все заказы" }
        
        let startStr = DateFormatManager.shared.getFormattedString(startDate, dateFormat: "d MMM")
        let endStr = DateFormatManager.shared.getFormattedString(endDate, dateFormat: "d MMM")
        
        return "Заказы за \(startStr) - \(endStr)"
    }
    
    @Published var supplies: [SupplyModel] = []
    
    private var updateFiltersPublisher: AnyPublisher<Void, Never> {
        Publishers.CombineLatest3(
            $startDate.removeDuplicates(),
            $endDate.removeDuplicates(),
            $supplyStatuses.removeDuplicates()
        )
        .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
        .map { _, _, _ in () }.eraseToAnyPublisher()
    }
    
    init(supplyService: SupplyServiceProtocol = SupplyService()) {
        self.supplyService = supplyService
        fetchSupplies()
        
        setupBindings()
    }
    
    private func setupBindings() {
        updateFiltersPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchSupplies()
            }.store(in: &cancellableSet)
    }
    
    func fetchSupplies() {
        let filter = SupplyFilterDto(
            startDate: startDate?.toString(),
            endDate: endDate?.toString(),
            outgoingSupply: true,
            incomingSupply: false,
            branchId: AuthManager.shared.authData?.branchId
        )
        
        supplyService.getSupplies(filter: filter) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self else {
                    AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                    return
                }
                let receivedSupplies = response
                    .filter { dto in
                        guard let status = dto.statuses?.last?.status else { return true }
                        return self.supplyStatuses.isEmpty || self.supplyStatuses.contains(status)
                    }
                    .map { dto in
                        SupplyModel.from(dto)
                    }
                
                self.supplies = receivedSupplies
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
}
