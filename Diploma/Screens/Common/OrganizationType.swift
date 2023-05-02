import Foundation

enum OrganizationType: String, Codable, CaseIterable {
    case worker = "WORKER"
    case supplier = "SUPPLIER"
    
    var name: String {
        switch self {
        case .worker:
            return "Сбыт"
        case .supplier:
            return "Поставки"
        }
    }
}
