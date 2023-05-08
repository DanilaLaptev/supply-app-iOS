import Foundation
import SwiftUI

struct ProductModel {
    var id: Int = UUID().hashValue
    var name: String
    var isApproved: Bool
    var type: ProductType
    
    static let empty = ProductModel(
        name: "none",
        isApproved: false,
        type: .other
    )
}
