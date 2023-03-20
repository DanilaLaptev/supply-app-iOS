import Foundation
import SwiftUI

final class ViewTools: ObservableObject {
    @Published private(set) var bottomBarIsVisible: Bool = false
    @Published private(set) var alertsList: [AlertModel] = []
    private let alertsLimit = 3
    
    func setBottomBarVisibility(_ isVisible: Bool) {
        bottomBarIsVisible = isVisible
    }
    
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

