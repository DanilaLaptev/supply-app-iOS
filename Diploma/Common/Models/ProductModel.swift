import Foundation

enum ProductType: String, CaseIterable {
    case meat = "Мясо"
    case fish = "Рыба"
    case milk = "Молочные продукты"
    case bakery = "Выпечка"
    case cereals = "Крупы"
    case vegetables = "Овощи"
    case fruits = "Фрукты"
    case berries = "Ягоды"
    case drinks = "Напитки"
    case other = "Другое"
}

struct ProductModel {
    static let empty = ProductModel(
        name: "none",
        isApproved: false,
        type: .other
    )
    
    var name: String
    var isApproved: Bool
    var type: ProductType
}
