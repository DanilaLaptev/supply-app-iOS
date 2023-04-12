import Foundation
import SwiftUI
import Combine

struct ProductTag<TagEnum: TagsGroupProtocol>: Identifiable {
    let id = UUID()
    let type: TagEnum
    var isSelected: Bool
}

class TagsGroupViewModel<TagEnum: TagsGroupProtocol>: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private(set) var tags: [ProductTag<TagEnum>] = []
    @Published var noTagsSelected = true

    private var noTagsSelectedPublisher: AnyPublisher<Bool, Never> {
        $tags
            .map { tags -> Bool in
                !tags.contains { $0.isSelected }
            }.eraseToAnyPublisher()
    }
    
    init() {
        tags = TagEnum.allCases.map { ProductTag(type: $0, isSelected: false) }
        
        noTagsSelectedPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] noTags in
                self?.noTagsSelected = noTags
            }
            .store(in: &cancellableSet)
    }
    
    func toggleTag(_ type: TagEnum) {
        guard let index = tags.firstIndex(where: { $0.type == type }) else { return }
        
        var tempTags = tags
        tempTags[index].isSelected.toggle()
        tags = tempTags
    }
    
    func clearFilters() {
        for index in 0..<tags.count {
            tags[index].isSelected = false
        }
    }
}
