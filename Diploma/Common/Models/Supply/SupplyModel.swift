import Foundation

struct SupplyStatusHistory {
    let status: SupplyStatus
    let created: Date
}

struct SupplyModel: Identifiable {
    var id = UUID().hashValue
    var publicId: Int
    var products: [StorageItemModel]
    var statusHistory: [SupplyStatusHistory]
    var deliveryTime: Date
    var created: Date
    var fromOrganizationCommentary: String
    var totalPrice: Double
}

extension SupplyModel {
    static var empty: SupplyModel { SupplyModel(id: UUID().hashValue,
                                                publicId: 0,
                                                products: [],
                                                statusHistory: [],
                                                deliveryTime: Date(),
                                                created: Date(),
                                                fromOrganizationCommentary: "commentary",
                                                totalPrice: 0) }
    
    static var test: SupplyModel { SupplyModel(id: UUID().hashValue,
                                               publicId: 12733,
                                               products: [
                                                StorageItemModel(
                                                    product: ProductModel(
                                                        name: "name",
                                                        isApproved: true,
                                                        type: .bakery
                                                    ),
                                                    imageUrl: "",
                                                    price: 103,
                                                    quantity: 23,
                                                    description: "product product product"
                                                ),
                                                StorageItemModel(
                                                    product: ProductModel(
                                                        name: "name",
                                                        isApproved: true,
                                                        type: .bakery
                                                    ),
                                                    imageUrl: "",
                                                    price: 103,
                                                    quantity: 23,
                                                    description: "product product product"
                                                ),
                                                StorageItemModel(
                                                    product: ProductModel(
                                                        name: "name",
                                                        isApproved: true,
                                                        type: .bakery
                                                    ),
                                                    imageUrl: "",
                                                    price: 103,
                                                    quantity: 23,
                                                    description: "product product product"
                                                ),
                                                StorageItemModel(
                                                    product: ProductModel(
                                                        name: "name",
                                                        isApproved: true,
                                                        type: .bakery
                                                    ),
                                                    imageUrl: "",
                                                    price: 103,
                                                    quantity: 23,
                                                    description: "product product product"
                                                )
                                               ],
                                               statusHistory: [
                                                SupplyStatusHistory(status: .denied, created: Date())
                                               ],
                                               deliveryTime: Date(),
                                               created: Date(),
                                               fromOrganizationCommentary: "commentary",
                                               totalPrice: 0) }
}
