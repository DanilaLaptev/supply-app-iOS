import Foundation

enum SupplyStatus: Int {
    case denied = -1
    case inProgress = 0
    case approved = 1
    case inTransit = 2
    case delivered = 3
    case orderAccepted = 4
    
    var name: String {
        switch self {
        case .denied:
            return "Отклонено"
        case .inProgress:
            return "Обрабатывается"
        case .approved:
            return "Одобрен"
        case .inTransit:
            return "В пути"
        case .delivered:
            return "Доставлен"
        case .orderAccepted:
            return "Принят"
        }
    }
}
