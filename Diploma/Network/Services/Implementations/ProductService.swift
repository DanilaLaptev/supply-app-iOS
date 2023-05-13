import Foundation
import Moya

struct ProductService: ProductServiceProtocol {
    private let provider: MoyaProvider<ProductProvider>
    
    init(provider: MoyaProvider<ProductProvider> = MoyaProvider<ProductProvider>(plugins: [NetworkLoggerPlugin()])) {
        self.provider = provider
    }
    
    func getAllProducts(completion: @escaping (Result<[ProductDto], Error>) -> ()) {
        provider.request(.getAllProducts) { result in
            completion(result.handleResponse([ProductDto].self))
        }
    }
    
    func createProduct(completion: @escaping (Result<EmptyDto, Error>) -> ()) {
        provider.request(.createProduct) { result in
            completion(result.handleResponse(EmptyDto.self))
        }
    }
}
