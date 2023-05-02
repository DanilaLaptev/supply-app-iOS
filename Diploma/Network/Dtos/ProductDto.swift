import Foundation

struct ProductDto: Codable {
    var id: Int?
    var productType: ProductType?
    var name: String?
    var approved: Bool?
    var image: String
}
