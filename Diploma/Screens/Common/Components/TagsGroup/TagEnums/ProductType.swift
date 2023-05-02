import Foundation
import SwiftUI

enum ProductType: String, Codable, TagsGroupProtocol {
    case meat = "MEAT"
    case fish = "FISH"
    case milk = "MILK"
    case bakery = "BAKERY"
    case cereals = "CEREALS"
    case vegetables = "VEGETABLES"
    case fruits = "FRUITS"
    case berries = "BERRIES"
    case drinks = "DRINKS"
    case other = "OTHER"
    
    var name: String {
        switch self {
        case .meat:
            return "Мясо"
        case .fish:
            return "Рыба"
        case .milk:
            return "Молочные продукты"
        case .bakery:
            return "Выпечка"
        case .cereals:
            return "Крупы"
        case .vegetables:
            return "Овощи"
        case .fruits:
            return "Фрукты"
        case .berries:
            return "Ягоды"
        case .drinks:
            return "Напитки"
        case .other:
            return "Другое"
        }
    }
    
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
