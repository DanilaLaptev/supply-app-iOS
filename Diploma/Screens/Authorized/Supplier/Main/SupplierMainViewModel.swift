import Foundation
import SwiftUI
import Combine
import Moya


class SupplierMainViewModel: ObservableObject {
    private let organizationBranchProvider = MoyaProvider<OrganizationBranchProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var authManager = AuthManager.shared
    
    @Published var storageItems: [StorageItemModel] = []
    @Published var selectedProductTypes: [ProductType] = []
    
    @Published var showEditScreen = false
    @Published var showProductScreen = false

    @Published private(set) var editedProduct: StorageItemModel?
    @Published private(set) var selectedProduct: StorageItemModel?
    @Published private(set) var productToHide: StorageItemModel?

    @Published var showHideProductAlert = false

    
    private var selectedProducPublisher: AnyPublisher<StorageItemModel, Never> {
        $selectedProduct
            .compactMap { $0 }.eraseToAnyPublisher()
    }
    
    private var productToHidePublisher: AnyPublisher<StorageItemModel, Never> {
        $productToHide
            .compactMap { $0 }.eraseToAnyPublisher()
    }
    
    private var page = 0
    private let perPage = 10
    
    init() {
        fetchStorageItems()

        $editedProduct
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] productModel in
                self?.showEditScreen.toggle()
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
                    let receivedStorageItems =  response.items.map { item -> StorageItemModel in
                        StorageItemModel.from(item)
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
    
    func hideProductRequest() {
        guard let productToHide else {
            AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
            return
        }
        let requestBody = StorageItemDto(
            id: productToHide.id,
            isHidden: !productToHide.isHidden
        )
        
        organizationBranchProvider.request(.updateStorageItem(
            branchId: AuthManager.shared.authData?.branchId ?? -1,
            item: requestBody
        )) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    AlertManager.shared.showAlert(.init(type: .success, description: "Товар скрыт!"))
                    self?.refreshData()
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
    
    func hideStorageItem(_ product: StorageItemModel) {
        self.productToHide = product
    }
    
    func openEditView(_ product: StorageItemModel? = nil) {
        self.editedProduct = product
    }
    
    func openProductView(_ product: StorageItemModel) {
        self.selectedProduct = product
    }
}
