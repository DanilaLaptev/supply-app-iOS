import Foundation
import SwiftUI
import Combine


class EditProductViewModel: ObservableObject {
    var updateBindings: UpdateBindingsProtocol?
    var navigation: NavigationProtocol?
    private let organizationBranchService: OrganizationBranchServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    @Published private var initialStorageItem: StorageItemModel?
    
    @Published var price = ""
    @Published var description = ""
    @Published var imageUrl = ""
    
    @Published private(set) var descriptionValidation = ""
    @Published private(set) var priceValidation = ""
    
    private let branchId = AuthManager.shared.authData?.branchId ?? -1
    
    public var isDescriptionValid: AnyPublisher<String, Never> {
        $description
            .map { descrition in
                guard !descrition.isEmpty else {
                    return FormError.requiredField(source: "Описание").localizedDescription
                }
                return ""
            }.eraseToAnyPublisher()
    }
    
    public var isPriceValid: AnyPublisher<String, Never> {
        $price
            .map { price in
                guard !price.isEmpty else {
                    return FormError.requiredField(source: "Цена").localizedDescription
                }
                
                guard Int(price) != nil else {
                    return FormError.wrongFormat(source: "Цена").localizedDescription
                }
                
                return ""
            }.eraseToAnyPublisher()
    }
    
    init(organizationBranchService: OrganizationBranchServiceProtocol = OrganizationBranchService()) {
        self.organizationBranchService = organizationBranchService
        
        setupBindings()
    }
    
    private func setupBindings() {
        isPriceValid
            .receive(on: RunLoop.main)
            .sink { [weak self] valid in
                self?.priceValidation = valid
            }.store(in: &cancellableSet)
        
        isDescriptionValid
            .receive(on: RunLoop.main)
            .sink { [weak self] valid in
                self?.descriptionValidation = valid
            }.store(in: &cancellableSet)
        
        $initialStorageItem
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] storageItem in
                self?.price = String(Int(storageItem.price))
                self?.description = storageItem.description
                self?.imageUrl = storageItem.imageUrl
            }.store(in: &cancellableSet)
    }
    
    private func validateForm() -> Bool {
        guard descriptionValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: descriptionValidation))
            return false
        }
        
        guard priceValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: priceValidation))
            return false
        }
        
        return true
    }
    
    func updateStorageItem() {
        guard validateForm() else {
            return
        }
        
        let requestBody = StorageItemDto(
            id: initialStorageItem?.id,
            price: Double(price),
            description: description
        )
        
        organizationBranchService.updateStorageItem(
            branchId: branchId,
            item: requestBody
        ) { [weak self] result in
            switch result {
            case .success:
                AlertManager.shared.showAlert(.init(type: .success, description: "Товар обновлен!"))
                self?.updateBindings?.update()
                self?.navigation?.back()
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
    
    func setup(_ storageItem: StorageItemModel?) {
        initialStorageItem = storageItem
    }
}
