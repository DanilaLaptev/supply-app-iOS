import Foundation
import SwiftUI
import Combine
import Moya


class SupplierOrdersViewModel: ObservableObject {
    private let supplyProvider = MoyaProvider<SupplyProvider>(plugins: [NetworkLoggerPlugin()])
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
    
    init() {
        fetchSupplies()
        
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
        
        supplyProvider.request(.getSupplies(filter: filter)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let self,
                          let response = try? response.map([SupplyDto].self) else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                        return
                    }
                    let receivedSupplies = response
                        .filter { dto in
                            guard let status = dto.statuses?.first?.status else { return true }
                            return self.supplyStatuses.isEmpty || self.supplyStatuses.contains(status)
                        }
                        .map { dto in
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
