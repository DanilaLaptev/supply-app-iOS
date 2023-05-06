import SwiftUI

struct GroupTag<TagEnum: TagsGroupProtocol>: Identifiable {
    let id = UUID()
    let type: TagEnum
    var isSelected: Bool
}

struct SmallTagsGroup<TagEnum: TagsGroupProtocol>: View {
    var selectAllOption: Bool = true
    @Binding var selectedTags: [TagEnum]
    @State private var tags = TagEnum.allCases.map { GroupTag(type: $0, isSelected: false) }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if selectAllOption {
                    SmallTag(icon: .customBox,
                             name: "Все",
                             isSelected: selectedTags.isEmpty)
                    .onTapGesture {
                        self.clearFilters()
                        selectedTags = []
                    }
                }

                ForEach(tags) { tag in
                    SmallTag(icon: tag.type.icon,
                             name: tag.type.name,
                             isSelected: tag.isSelected )
                        .onTapGesture {
                            self.toggleTag(tag.type)
                            selectedTags = self.tags.filter { $0.isSelected }.map { $0.type }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    func toggleTag(_ type: TagEnum) {
        guard let index = tags.firstIndex(where: { $0.type == type }) else { return }
        
        var tempTags = tags
        tempTags[index].isSelected.toggle()
        self.tags = tempTags
    }
    
    func clearFilters() {
        for index in 0..<tags.count {
            tags[index].isSelected = false
        }
    }
}

struct SmallTagsGroup_Previews: PreviewProvider {
    static var previews: some View {
        SmallTagsGroup<ProductType>(selectedTags: .constant([]))
        SmallTagsGroup<ProductType>(selectedTags: .constant([]))
    }
}
