import Foundation
import SwiftUI

struct ProductModel: Identifiable, Hashable {
    var id: Int = UUID().hashValue
    var name: String
    var isApproved: Bool
    var type: ProductType
    var imageURL: String

    static let empty = ProductModel(
        name: "none",
        isApproved: false,
        type: .other,
        imageURL: "none"
    )
    
    static func from(_ dto: ProductDto) -> ProductModel {
        ProductModel(
            id: dto.id ?? -1,
            name: dto.name ?? "none",
            isApproved: dto.approved ?? false,
            type: dto.productType ?? .other,
            imageURL: dto.image ?? "none"
        )
    }
}
