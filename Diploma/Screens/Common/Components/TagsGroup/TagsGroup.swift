import SwiftUI

struct TagsGroup<TagEnum: TagsGroupProtocol>: View {
    var selectAllOption: Bool = true
    
    @ObservedObject private var viewModel = TagsGroupViewModel<TagEnum>()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if selectAllOption {
                    SmallTag(icon: .customBox,
                             name: "Все",
                             isSelected: viewModel.noTagsSelected)
                    .onTapGesture {
                        viewModel.clearFilters()
                    }
                }

                ForEach(viewModel.tags) { tag in
                    SmallTag(icon: tag.type.icon,
                             name: tag.type.name,
                             isSelected: tag.isSelected )
                        .onTapGesture {
                            viewModel.toggleTag(tag.type)
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct TagsGroup_Previews: PreviewProvider {
    static var previews: some View {
        TagsGroup<ProductType>()
        TagsGroup<ProductType>()
    }
}
