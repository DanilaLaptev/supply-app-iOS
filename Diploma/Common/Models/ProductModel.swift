import Foundation
import SwiftUI

struct ProductModel {
    var name: String
    var isApproved: Bool
    var type: ProductType
    
    static let empty = ProductModel(
        name: "none",
        isApproved: false,
        type: .other
    )
}
