import Foundation
import SwiftUI
import Combine


class WorkerMainViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var viewManager = ViewManager.shared
    @Published private var authManager = AuthManager.shared
    
    @Published var storageItems: [StorageItemWrapper] = []
    @Published var selectedStorageItems: [StorageItemModel] = []
    
    @Published var disableSupplyButton = false
    @Published var totalPrice: Double = 0

    @Published var editStorageItemActive = false
    @Published var editedStorageItem: StorageItemModel? = nil

    @Published var supply: SupplyModel? = nil
    
    @Published var enableSaveSupplyButton = false
    
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
        fetchStorageItems()
        
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
    }
    
    func fetchStorageItems() {
        viewManager.isLoading = true
        
        // TODO: request to fetch items
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in

            guard let self = self else { return }
            self.viewManager.isLoading = false
            
            self.storageItems = [
                StorageItemModel(product: ProductModel(
                    name: "Coca cola 1.0",
                    isApproved: true,
                    type: .drinks
                ),
                                 imageUrl: "https://mundolatas.com/wp-content/uploads/coca-cola-1080x675.jpg",
                                 price: 42,
                                 quantity: 5,
                                 description: "Газированный напиток"),
                StorageItemModel(product: ProductModel(
                    name: "Fanta 0.5",
                    isApproved: true,
                    type: .drinks
                ),
                                 imageUrl: "https://i.ytimg.com/vi/ZZWOT7HLA48/maxresdefault.jpg",
                                 price: 45,
                                 quantity: 32,
                                 description: "Газированный напиток"),
                StorageItemModel(product: ProductModel(
                    name: "Булочка с маком",
                    isApproved: true,
                    type: .bakery
                ),
                                 imageUrl: "https://british-bakery.ru/upload/iblock/0ad/0add711ccc5a2523929b5c1e26f6a49a.jpg",
                                 price: 25,
                                 quantity: 20,
                                 description: "Выпечка"),
                StorageItemModel(product: ProductModel(
                    name: "Сдобная булочка",
                    isApproved: true,
                    type: .bakery
                ),
                                 imageUrl: "https://static.1000.menu/img/content-v2/8a/8c/43270/bulochki-s-saxarom-iz-sdobnogo-drojjevogo-testa_1582100715_16_max.jpg",
                                 price: 25,
                                 quantity: 20,
                                 description: "Выпечка"),
                
            ]
                .map { StorageItemWrapper(item: $0, selectedAmmount: 0) }
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
