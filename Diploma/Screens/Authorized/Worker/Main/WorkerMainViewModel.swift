import Foundation
import SwiftUI
import Combine


class WorkerMainViewModel: ObservableObject {
    private let organizationBranchService: OrganizationBranchServiceProtocol
    private let supplyService: SupplyServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var viewManager = ViewManager.shared
    @Published private var authManager = AuthManager.shared
    
    @Published var storageItems: [StorageItemWrapper] = []
    @Published var selectedStorageItems: [StorageItemModel] = []
    
    @Published var selectedProductTypes: [ProductType] = []
    
    @Published var disableSupplyButton = false
    @Published var totalPrice: Double = 0
    
    @Published var editStorageItemActive = false
    @Published var editedStorageItem: StorageItemModel? = nil
    
    private var page = 0
    private let perPage = 10
    
    private var selectedProductsPublisher: AnyPublisher<[StorageItemWrapper], Never> {
        $storageItems
            .map { wrappedItems in
                wrappedItems.filter { $0.selectedAmmount > 0 }
            }.eraseToAnyPublisher()
    }
    
    private var totalPricePublisher: AnyPublisher<Double, Never> {
        selectedProductsPublisher
            .map { selectedItems in
                selectedItems
                    .map { Double($0.selectedAmmount) * $0.item.price }
                    .reduce(0, +)
            }.eraseToAnyPublisher()
    }
    
    init(
        organizationBranchService: OrganizationBranchServiceProtocol = OrganizationBranchService(),
        supplyService: SupplyServiceProtocol = SupplyService()
    ) {
        self.organizationBranchService = organizationBranchService
        self.supplyService = supplyService
        fetchStorageItems()
        
        setupBindings()
    }
    
    private func setupBindings() {
        selectedProductsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedProducts in
                self?.disableSupplyButton = selectedProducts.isEmpty
            }.store(in: &cancellableSet)
        
        
        selectedProductsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedProducts in
                self?.selectedStorageItems = selectedProducts.map({ itemWrapper in
                    var tempItem = itemWrapper.item
                    tempItem.quantity = itemWrapper.selectedAmmount
                    return tempItem
                })
            }.store(in: &cancellableSet)
        
        totalPricePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] totalPrice in
                self?.totalPrice = totalPrice
            }.store(in: &cancellableSet)
        
        $selectedProductTypes
            .dropFirst()
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] selected in
                self?.refreshData()
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
        
        let branchId = authManager.authData?.branchId ?? -1
        
        organizationBranchService.getStorageItems(branchId: branchId, filter: filter) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self,
                      let total = response.total else {
                    AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                    return
                }
                let receivedStorageItems =  response.items.map { item -> StorageItemWrapper in
                    StorageItemWrapper(item: StorageItemModel.from(item), selectedAmmount: 0)
                }
                
                self.storageItems += receivedStorageItems
                self.page = total > self.storageItems.count ? self.page + 1 : -1
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
    
    func sellStorageItems() {
        let supply = SupplyDto(
            fromBranch: authManager.authData?.branchId ?? -1,
            deliveryTime: Date().toString(),
            items: selectedStorageItems.map({ storageItem -> StorageItemDto in
                StorageItemDto(id: storageItem.id, quantity: storageItem.quantity)
            })
        )
        
        supplyService.sellSupply(supply: supply) { [weak self] result in
            switch result {
            case .success:
                AlertManager.shared.showAlert(.init(type: .success, description: "Покупка сохранена"))
                self?.refreshData()
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
    
    func refreshData() {
        page = 0
        storageItems = []
        selectedStorageItems = []
        fetchStorageItems()
    }
    
    func editProduct(_ storageItem: StorageItemModel) {
        editedStorageItem = storageItem
        editStorageItemActive.toggle()
    }
}
