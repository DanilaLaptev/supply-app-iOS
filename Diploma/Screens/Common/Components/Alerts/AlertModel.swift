import Foundation

struct AlertModel: Identifiable {
    let id = UUID()
    let type: AlertType
    let description: String
}
