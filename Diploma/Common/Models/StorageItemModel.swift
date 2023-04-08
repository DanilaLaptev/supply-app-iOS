import Foundation

struct StorageItemModel: Identifiable {
    static let empty = StorageItemModel(
        product: .empty,
        imageUrl: "none",
        price: 0,
        quantity: 0,
        description: "none"
    )
    
    var id = UUID().hashValue
    var product: ProductModel
    var imageUrl: String
    var price: Double
    var quantity: Int
    var description: String
}

