import Foundation

struct AlertModel: Identifiable {
    let id = UUID()
    let type: AlertType
    let description: String
    
    static func error(_ description: String = "Неизвестная ошибка") -> AlertModel {
        AlertModel(type: .error, description: description)
    }

}
