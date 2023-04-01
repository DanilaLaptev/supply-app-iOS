import Foundation

final class AlertManager: ObservableObject {
    static let shared = AlertManager()
    private init() { }
    
    @Published private(set) var alertsList: [AlertModel] = []
    private let alertsLimit = 3
    
    
    func showAlert(_ alert: AlertModel) {
        alertsList.insert(alert, at: 0)
        alertsList = alertsList.count > alertsLimit ? Array(alertsList[0..<alertsLimit]) : alertsList
    }
    
    func removeAlert(_ alert: AlertModel) {
        alertsList.removeAll { visibleAlert in
            visibleAlert.id == alert.id
        }
    }
    
    func removeAllAlerts() {
        alertsList = []
    }
}
