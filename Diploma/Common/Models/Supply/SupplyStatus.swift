import Foundation
import SwiftUI

enum SupplyStatus: String, Codable, TagsGroupProtocol {
    case pending = "PENDING"
    case denied = "DENIED"
    case approved = "APPROVED"
    case collected = "COLLECTED"
    case inTransit = "IN_TRANSIT"
    case delivered = "DELIVERED"
    case supplyAccepted = "SUPPLY_ACCEPTED"
    
    var name: String {
        switch self {
        case .denied:
            return "Отклонено"
        case .pending:
            return "Обрабатывается"
        case .approved:
            return "Одобрен"
        case .collected:
            return "Собран"
        case .inTransit:
            return "В пути"
        case .delivered:
            return "Доставлен"
        case .supplyAccepted:
            return "Принят"
        }
    }
    
    var icon: Image {
        switch self {
        default:
            return .customBox
        }
    }
}
