import Foundation
import SwiftUI
import Combine
import Moya


class CreateProductViewModel: ObservableObject {
    private var organizationBranchProvider = MoyaProvider<OrganizationBranchProvider>(plugins: [NetworkLoggerPlugin()])
    private var productProvider = MoyaProvider<ProductProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()

    @Published private(set) var products: [ProductModel] = []
    
    @Published var product: ProductModel?
    @Published var price = ""
    @Published var description = ""
    @Published private(set) var imageUrl = ""
    
    @Published private var productValidation = ""
    @Published private var descriptionValidation = ""
    @Published private var priceValidation = ""
    
    private var isProductValid: AnyPublisher<String, Never> {
        $product
            .map { product in
                guard product != nil else {
                    return FormError.requiredField(source: "Продукт").localizedDescription
                }
                return ""
            }.eraseToAnyPublisher()
    }
    
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
    
    private var productImageUrl: AnyPublisher<String, Never> {
        $product
            .compactMap { product -> String? in
                return URL(string: product?.imageURL ?? "none")?.absoluteString
            }.eraseToAnyPublisher()
    }
    
    
    
    init() {
        fetchProductsList()
        
        isProductValid
            .receive(on: RunLoop.main)
            .sink { [weak self] valid in
                self?.productValidation = valid
            }.store(in: &cancellableSet)
        
        productImageUrl
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                self?.imageUrl = url
            }.store(in: &cancellableSet)
        
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
    }
    
    private func validateForm() -> Bool {
        guard productValidation.isEmpty else {
            AlertManager.shared.showAlert(.init(type: .error, description: productValidation))
            return false
        }
        
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
    
    func fetchProductsList() {
        productProvider.request(.getAllProducts) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let self,
                          let response = try? response.map([ProductDto].self) else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                        return
                    }
                    self.products = response.map { ProductModel.from($0) }
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
    
    func createStorageItem() {
        guard validateForm() else {
            return
        }
        
        let requestBody = StorageItemDto(
            id: product?.id,
            price: Double(price),
            description: description,
            quantity: -1,
            isHidden: true
        )
        
        organizationBranchProvider.request(.addStorageItems(
            branchId: AuthManager.shared.authData?.branchId ?? -1,
            items: [requestBody]
        )) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    AlertManager.shared.showAlert(.init(type: .success, description: "Товар создан!"))
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
