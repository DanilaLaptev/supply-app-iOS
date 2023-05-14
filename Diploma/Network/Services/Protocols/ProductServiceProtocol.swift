import Foundation

protocol ProductServiceProtocol {
    func getAllProducts(completion: @escaping (Result<[ProductDto], Error>) -> ())
    func createProduct(completion: @escaping (Result<Void, Error>) -> ())
}
