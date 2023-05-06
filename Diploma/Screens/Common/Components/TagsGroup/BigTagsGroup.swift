import SwiftUI


struct BigTagsGroup<TagEnum: TagsGroupProtocol>: View {
    var selectAllOption: Bool = true
    @Binding var selectedTags: [TagEnum]
    @State private var tags = TagEnum.allCases.map { GroupTag(type: $0, isSelected: false) }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if selectAllOption {
                    BigTag(icon: .customBox,
                             name: "Все",
                             isSelected: selectedTags.isEmpty)
                    .onTapGesture {
                        self.clearFilters()
                        selectedTags = []
                    }
                }

                ForEach(tags) { tag in
                    BigTag(icon: tag.type.icon,
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

struct BigTagsGroup_Previews: PreviewProvider {
    static var previews: some View {
        BigTagsGroup<ProductType>(selectedTags: .constant([]))
        BigTagsGroup<ProductType>(selectedTags: .constant([]))
    }
}
