import Foundation
import SwiftUI
import Combine
import Moya


class SupplierViewModel: ObservableObject {
    private let organizationBranchProvider = MoyaProvider<OrganizationBranchProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    
    var organizationModel: OrganizationModel?
    
    @Published var storageItems: [StorageItemWrapper] = []
    @Published var selectedStorageItems: [StorageItemWrapper] = []

    @Published var selectedProductTypes: [ProductType] = []
    
    @Published var selectedItemsNumber = 0
    @Published var supplyTotalPrice: Double = 0
    @Published var disableSupplyButton: Bool = false
    
    private var page = 0
    private let perPage = 10
    
    private var updateFiltersPublisher: AnyPublisher<Void, Never> {
        $selectedProductTypes
            .removeDuplicates()
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .map { _ in () }.eraseToAnyPublisher()
    }
    
    private var selectedItemsPublisher: AnyPublisher<[StorageItemWrapper], Never> {
        $storageItems
            .print("items")
            .map { wrappedItems in
                wrappedItems.filter { $0.selectedAmmount > 0 }
            }.eraseToAnyPublisher()
    }
    
    private var selectedItemsNumberPublisher: AnyPublisher<Int, Never> {
        selectedItemsPublisher
            .map { items in
                items.map { $0.selectedAmmount }.reduce(0, +)
            }.eraseToAnyPublisher()
    }
    
    private var totalPricePublisher: AnyPublisher<Double, Never> {
        selectedItemsPublisher
            .map { wrappedItems in
                wrappedItems.map { Double($0.selectedAmmount) * $0.item.price }.reduce(0, +)
            }.eraseToAnyPublisher()
    }
    
    private var disableSupplyButtonPublisher: AnyPublisher<Bool, Never> {
        selectedItemsPublisher
            .map { items in
                items.isEmpty
            }.eraseToAnyPublisher()
    }
    
    init() {
        selectedItemsNumberPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] productsNumber in
                self?.selectedItemsNumber = productsNumber
            }.store(in: &cancellableSet)
        
        totalPricePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] price in
                self?.supplyTotalPrice = price
            }.store(in: &cancellableSet)
        
        disableSupplyButtonPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] disableButton in
                self?.disableSupplyButton = disableButton
            }.store(in: &cancellableSet)
        
        selectedItemsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] storageItems in
                self?.selectedStorageItems = storageItems
            }.store(in: &cancellableSet)
        
        updateFiltersPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.page = 0
                self?.storageItems = []
                self?.fetchStorageItems()
            }.store(in: &cancellableSet)
    }
 
    func fetchStorageItems() {
	        guard page != -1 else {
            return
        }
        
        let productTypes = selectedProductTypes.isEmpty ? nil : selectedProductTypes
        
        let filter = FilterDto(
            productType: productTypes,
            page: page,
            perPage: perPage
        )
        organizationBranchProvider.request(.getStorageItems(branchId: organizationModel?.branches.last?.id ?? -1, filter: filter)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let self,
                          let response = try? response.map(PaginatedDto<StorageItemDto>.self),
                          let total = response.total else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                        return
                    }
                    let receivedStorageItems = response.items.map { item -> StorageItemWrapper in
                        StorageItemWrapper(item: StorageItemModel.from(item), selectedAmmount: 0)
                    }
                    
                    self.storageItems += receivedStorageItems
                    self.page = total > self.storageItems.count ? self.page + 1 : -1
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
    
    func setup(organizationModel: OrganizationModel?) {
        self.organizationModel = organizationModel
    }
}
