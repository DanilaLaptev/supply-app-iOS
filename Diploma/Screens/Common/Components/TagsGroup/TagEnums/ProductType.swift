import Foundation
import SwiftUI

enum ProductType: String, TagsGroupProtocol {
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
    
    var name: String { self.rawValue }
    
    var icon: Image {
        switch self {
        case .meat:
            return .customBin
        case .fish:
            return .customChart
        case .milk:
            return .customChart
        case .bakery:
            return .customChart
        case .cereals:
            return .customChart
        case .vegetables:
            return .customChart
        case .fruits:
            return .customChart
        case .berries:
            return .customChart
        case .drinks:
            return .customChart
        case .other:
            return .customBox
        }
    }
}
