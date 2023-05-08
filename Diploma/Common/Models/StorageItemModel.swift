import Foundation

struct StorageItemModel: Identifiable {
    var id = UUID().hashValue
    var product: ProductModel
    var imageUrl: String
    var price: Double
    var quantity: Int
    var description: String
    var isHidden: Bool

    static let empty = StorageItemModel(
        id: UUID().hashValue,
        product: .empty,
        imageUrl: "none",
        price: 0,
        quantity: 0,
        description: "none",
        isHidden: false
    )
    
    static func from(_ dto: StorageItemDto) -> StorageItemModel {
        StorageItemModel(
            id: dto.id ?? -1,
            product: ProductModel(
                id: dto.product?.id ?? -1,
                name: dto.product?.name ?? "empty",
                isApproved: dto.product?.approved ?? false,
                type: dto.product?.productType ?? .other
            ),
            imageUrl: dto.product?.image ?? "none",
            price: dto.price ?? 0,
            quantity: dto.quantity ?? 0,
            description: dto.description ?? "empty",
            isHidden: dto.isHidden ?? false
        )
    }
}

