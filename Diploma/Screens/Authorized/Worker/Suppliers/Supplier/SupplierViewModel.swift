import Foundation
import SwiftUI
import Combine

class SupplierViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    var organizationModel: OrganizationModel?
    
    @Published var storageItems: [StorageItemWrapper] = []
    @Published var selectedStorageItems: [StorageItemWrapper] = []

    @Published var selectedItemsNumber = 0
    @Published var supplyTotalPrice: Double = 0
    @Published var disableSupplyButton: Bool = false
    
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
    }
 
    func setup(organizationModel: OrganizationModel?) {
        self.organizationModel = organizationModel
        self.storageItems = organizationModel?.storageItems.map { StorageItemWrapper(item: $0, selectedAmmount: 0) } ?? []
    }
}
