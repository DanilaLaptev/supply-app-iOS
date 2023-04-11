import Foundation

struct StorageItemModel: Identifiable {
    var id = UUID().hashValue
    var product: ProductModel
    var imageUrl: String
    var price: Double
    var quantity: Int
    var description: String
    
    static let empty = StorageItemModel(
        id: UUID().hashValue,
        product: .empty,
        imageUrl: "none",
        price: 0,
        quantity: 0,
        description: "none"
    )
}

