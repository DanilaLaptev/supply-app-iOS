import Foundation
import SwiftUI
import Combine

class WorkerOrdersViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    
    @Published var dateRangeTitle = ""
    
    private var dateRangeTitlePublisher: AnyPublisher<String, Never> {
        Publishers.CombineLatest($startDate,
                                 $endDate)
        .map { startDate, endDate -> String in
            guard let startDate, let endDate else { return "Все ваши заказы" }
            
            let startStr = DateFormatManager.shared.getFormattedString(startDate, dateFormat: "d MMM")
            let endStr = DateFormatManager.shared.getFormattedString(endDate, dateFormat: "d MMM")
            
            return "Заказы за \(startStr) - \(endStr)"
        }.eraseToAnyPublisher()
    }
    
    init() {
        dateRangeTitlePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] title in
                self?.dateRangeTitle = title
            }.store(in: &cancellableSet)
        
    }
    
}

