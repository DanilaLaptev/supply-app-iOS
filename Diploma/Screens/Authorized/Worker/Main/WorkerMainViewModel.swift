import Foundation
import SwiftUI
import Combine

class WorkerMainViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    let tags = ProductType.allCases.sorted(by: { $0.rawValue < $1.rawValue })
    
    @Published var storageItems = [StorageItemModel](repeating: .empty, count: 10)
    
    init() {
        
    }
}
