import Foundation

struct StorageItemDto: Codable {
    var id: Int?
    var price: Double?
    var description: String?
    var quantity: Int?
    var isHidden: Bool
    var product: ProductDto
}
