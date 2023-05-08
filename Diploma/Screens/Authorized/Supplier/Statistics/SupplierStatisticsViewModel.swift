import Foundation
import SwiftUI
import Combine
import Moya


class SupplierStatisticsViewModel: ObservableObject {
    private let supplyProvider = MoyaProvider<SupplyProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    @Published var supplies: [SupplyModel] = []

    @Published var incomingStatistics: ChartDataContainer = .empty
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
    
    private var incomingSuppliesStatistics: AnyPublisher<ChartDataContainer, Never> {
        $supplies
            .map { allSupplies -> ChartDataContainer in
                
                let allProducts = allSupplies
                    .filter  { supply in
                    supply.toBranchId == AuthManager.shared.authData?.branchId
                }
                    .flatMap { $0.products }
                
                let productsByType = Dictionary(grouping: allProducts, by: { $0.product.type })
                    .mapValues { $0.reduce(0) { $0 + $1.price } }

                let data = productsByType.map { key, sumPrice -> ChartData in
                    ChartData(name: key.name, value: sumPrice)
                }
                
                return ChartDataContainer(data)
            }.eraseToAnyPublisher()
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
                    .mapValues { $0.reduce(0) { $0 + $1.price } }

                let data = productsByType.map { key, sumPrice -> ChartData in
                    ChartData(name: key.name, value: sumPrice)
                }
                
                return ChartDataContainer(data)
            }.eraseToAnyPublisher()
    }
    
    init() {
        fetchSupplies()
        
        updateFiltersPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchSupplies()
            }.store(in: &cancellableSet)
        
        incomingSuppliesStatistics
            .receive(on: RunLoop.main)
            .sink { [weak self] statistics in
                self?.incomingStatistics = statistics
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
        
        supplyProvider.request(.getSupplies(filter: filter)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let self,
                          let response = try? response.map([SupplyDto].self) else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                        return
                    }
                    let receivedSupplies = response.map { dto in
                            SupplyModel.from(dto)
                        }
                    
                    self.supplies = receivedSupplies
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
