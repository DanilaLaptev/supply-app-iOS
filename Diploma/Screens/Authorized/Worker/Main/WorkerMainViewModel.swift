import Foundation
import SwiftUI
import Combine
import Moya


class WorkerMainViewModel: ObservableObject {
    private let organizationBranchProvider = MoyaProvider<OrganizationBranchProvider>(plugins: [NetworkLoggerPlugin()])
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
    
    init() {
        selectedProductsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedProducts in
                self?.disableSupplyButton = selectedProducts.isEmpty
            }.store(in: &cancellableSet)
        
        totalPricePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] totalPrice in
                self?.totalPrice = totalPrice
            }.store(in: &cancellableSet)
        
        $selectedProductTypes
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] selected in
                self?.page = 0
                self?.storageItems = []
                self?.selectedStorageItems = []
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
        organizationBranchProvider.request(.getStorageItems(branchId: authManager.authData?.branchId ?? -1, filter: filter)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let self,
                          let response = try? response.map(PaginatedDto<StorageItemDto>.self),
                          let total = response.total else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                        return
                    }
                    let receivedStorageItems =  response.items.map { item -> StorageItemWrapper in
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
    
    func editProduct(_ storageItem: StorageItemModel) {
        editedStorageItem = storageItem
        editStorageItemActive.toggle()
    }
    
    func hideStorageItem(_ storageItem: StorageItemModel) {
        viewManager.isLoading = true
        
        // TODO: request to hide item
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            
            guard let self = self else { return }
            self.viewManager.isLoading = false
            
            self.fetchStorageItems()
        }
    }
}
