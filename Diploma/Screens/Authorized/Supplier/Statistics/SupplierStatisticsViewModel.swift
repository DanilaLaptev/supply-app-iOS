import Foundation
import SwiftUI
import Combine


class SupplierStatisticsViewModel: ObservableObject {
    private let supplyService: SupplyServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    @Published var supplies: [SupplyModel] = []
    
    @Published var outcomingStatistics: ChartDataContainer = .empty
    
    var dateRangeTitle: String {
        guard let startDate, let endDate else { return "Вся статистика" }
        
        let startStr = DateFormatManager.shared.getFormattedString(startDate, dateFormat: "d MMM")
        let endStr = DateFormatManager.shared.getFormattedString(endDate, dateFormat: "d MMM")
        
        return "Статистика за \(startStr) - \(endStr)"
    }
    
    private var updateFiltersPublisher: AnyPublisher<Void, Never> {
        Publishers.CombineLatest(
            $startDate.removeDuplicates(),
            $endDate.removeDuplicates()
        )
        .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
        .map { _, _ in () }.eraseToAnyPublisher()
    }
    
    private var outcomingSuppliesStatistics: AnyPublisher<ChartDataContainer, Never> {
        $supplies
            .map { allSupplies -> ChartDataContainer in
                
                let allProducts = allSupplies
                    .filter  { supply in
                        supply.fromBranchId == AuthManager.shared.authData?.branchId
                    }
                    .flatMap { $0.products }
                
                let productsByType = Dictionary(grouping: allProducts, by: { $0.product.type })
                    .mapValues { $0.reduce(0) { $0 + $1.price * Double($1.quantity) } }
                
                let data = productsByType.map { key, sumPrice -> ChartData in
                    ChartData(name: key.name, value: sumPrice)
                }
                
                return ChartDataContainer(data)
            }.eraseToAnyPublisher()
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
        
        outcomingSuppliesStatistics
            .receive(on: RunLoop.main)
            .sink { [weak self] statistics in
                self?.outcomingStatistics = statistics
            }.store(in: &cancellableSet)
    }
    
    func fetchSupplies() {
        let filter = SupplyFilterDto(
            startDate: startDate?.toString(),
            endDate: endDate?.toString(),
            outgoingSupply: true,
            incomingSupply: true,
            branchId: AuthManager.shared.authData?.branchId
        )
        
        supplyService.getSupplies(filter: filter) { [weak self] result in
            switch result {
            case .success(let response):
                let receivedSupplies = response.map { dto in
                    SupplyModel.from(dto)
                }
                
                self?.supplies = receivedSupplies
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
}
