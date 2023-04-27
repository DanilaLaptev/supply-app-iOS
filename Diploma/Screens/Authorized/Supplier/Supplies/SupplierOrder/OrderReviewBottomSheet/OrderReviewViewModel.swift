import Foundation
import SwiftUI
import Combine

struct RejectionItem: Identifiable {
    let id = UUID()
    var selected: Bool = false
    var name: String
}

class OrderReviewViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private(set) var rejectionReasonsList = [
        RejectionItem(name: "Недостаточная сумма заказа"),
        RejectionItem(name: "Склад находится слишком далеко от точки питания"),
        RejectionItem(name: "Отсутствуют необходимые товары"),
        RejectionItem(name: "Слишком мало времени на оформление закзаза")
    ]
    
    init() {
        
    }
    
    func selectReason(_ id: UUID) {
        rejectionReasonsList = rejectionReasonsList.map { rejectionItem in
            var tempItem = rejectionItem
            tempItem.selected = rejectionItem.id == id
            return tempItem
        }
    }
    
}
