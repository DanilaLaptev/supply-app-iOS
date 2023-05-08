import Foundation
import SwiftUI
import Combine
import Moya


class EditProductViewModel: ObservableObject {
    private var organizationBranchProvider = MoyaProvider<OrganizationBranchProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    @Published private var initialStorageItem: StorageItemModel?

    @Published var price = ""
    @Published var description = ""
    @Published var imageUrl = ""
    
    @Published private var descriptionValidation = ""
    @Published private var priceValidation = ""
    
    private var isDescriptionValid: AnyPublisher<String, Never> {
        $description
            .map { descrition in
                guard !descrition.isEmpty else {
                    return FormError.requiredField(source: "Описание").localizedDescription
                }
                return ""
            }.eraseToAnyPublisher()
    }
    
    private var isPriceValid: AnyPublisher<String, Never> {
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
    
    init() {
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
        
        organizationBranchProvider.request(.updateStorageItem(
            branchId: AuthManager.shared.authData?.branchId ?? -1,
            item: requestBody
        )) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    AlertManager.shared.showAlert(.init(type: .success, description: "Товар обновлен!"))
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
    
    func setup(_ storageItem: StorageItemModel?) {
        initialStorageItem = storageItem
    }
}
