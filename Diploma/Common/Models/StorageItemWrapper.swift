import Foundation

class StorageItemWrapper: ObservableObject, Identifiable, Equatable {
    static func == (lhs: StorageItemWrapper, rhs: StorageItemWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID().hashValue
    var item: StorageItemModel
    @Published var selectedAmmount: Int
    
    init(item: StorageItemModel, selectedAmmount: Int) {
        self.item = item
        self.selectedAmmount = selectedAmmount
    }
}
