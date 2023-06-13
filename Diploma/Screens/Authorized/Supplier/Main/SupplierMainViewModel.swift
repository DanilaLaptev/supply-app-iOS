import Foundation
import SwiftUI
import Combine


class SupplierMainViewModel: ObservableObject {
    private let organizationBranchService: OrganizationBranchServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var authManager = AuthManager.shared
    
    @Published var storageItems: [StorageItemModel] = []
    @Published var selectedProductTypes: [ProductType] = []
    
    @Published var showEditScreen = false
    @Published var showProductScreen = false
    @Published var showCreateProductView = false

    @Published var newProductCreated: Bool = false
    @Published var editedProduct: StorageItemModel?
    @Published private(set) var selectedProduct: StorageItemModel?
    @Published private(set) var productToHide: StorageItemModel?
    
    @Published var showHideProductAlert = false
    
    private var branchId = AuthManager.shared.authData?.branchId ?? -1
    
    private var selectedProducPublisher: AnyPublisher<StorageItemModel, Never> {
        $selectedProduct
            .compactMap { $0 }.eraseToAnyPublisher()
    }
    
    private var productToHidePublisher: AnyPublisher<StorageItemModel, Never> {
        $productToHide
            .compactMap { $0 }.eraseToAnyPublisher()
    }
    
    private(set) var page = 0
    private let perPage = 10
    
    init(organizationBranchService: OrganizationBranchServiceProtocol = OrganizationBranchService()) {
        self.organizationBranchService = organizationBranchService
        fetchStorageItems()
        
        setupBindings()
    }
    
    private func setupBindings() {
        $editedProduct
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] editedItem in
                self?.showEditScreen.toggle()
                self?.updateStorageItem(editedItem)
            }.store(in: &cancellableSet)
        
        productToHidePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] productModel in
                self?.showHideProductAlert.toggle()
            }.store(in: &cancellableSet)
        
        selectedProducPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] productModel in
                self?.showProductScreen.toggle()
            }.store(in: &cancellableSet)
        
        $selectedProductTypes
            .dropFirst()
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] selected in
                self?.refreshData()
            }.store(in: &cancellableSet)
        
        $newProductCreated
            .filter { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.refreshData()
            }.store(in: &cancellableSet)
    }
    
    func refreshData() {
        page = 0
        storageItems = []
        fetchStorageItems()
    }
    
    func fetchStorageItems() {
        guard page != -1 else {
            return
        }
        
        let productTypes = selectedProductTypes.isEmpty ? nil : selectedProductTypes
        
        let filter = FilterDto(
            hidden: true,
            productType: productTypes,
            page: page,
            perPage: perPage
        )
                
        organizationBranchService.getStorageItems(branchId: branchId, filter: filter) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self,
                      let total = response.total else {
                    AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                    return
                }
                let receivedStorageItems =  response.items.map { item -> StorageItemModel in
                    StorageItemModel.from(item)
                }
                
                self.storageItems += receivedStorageItems
                self.page = total > self.storageItems.count ? self.page + 1 : -1
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
    
    func hideProductRequest() {
        guard var productToHide else {
            AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
            return
        }
        productToHide.isHidden.toggle()
        
        let requestBody = StorageItemDto(
            id: productToHide.id,
            isHidden: productToHide.isHidden
        )
        
        organizationBranchService.updateStorageItem(
            branchId: branchId,
            item: requestBody
        ) { [weak self] result in
            switch result {
            case .success:
                AlertManager.shared.showAlert(.init(type: .success, description: "Операция выполнена!"))
                self?.updateStorageItem(productToHide)
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
    
    func hideStorageItem(_ product: StorageItemModel) {
        self.productToHide = product
    }
    
    func openEditView(_ product: StorageItemModel? = nil) {
        self.editedProduct = product
    }
    
    func openCreateProductView() {
        self.showCreateProductView.toggle()
    }
    
    func openProductView(_ product: StorageItemModel) {
        self.selectedProduct = product
    }
    
    func updateStorageItem(_ editedItem: StorageItemModel) {
        guard let index = storageItems.firstIndex(where: {$0.id == editedItem.id}) else {
            return
        }
        storageItems[index] = editedItem
    }
}
