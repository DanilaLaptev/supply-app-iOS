import SwiftUI

struct TagsGroup: View {
    @ObservedObject private var viewModel = TagsGroupViewModel()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                SmallTag(icon: .customBox,
                         name: "Все",
                         isSelected: viewModel.noTagsSelected)
                .onTapGesture {
                    viewModel.clearFilters()
                }
                ForEach(viewModel.tags) { tag in
                    SmallTag(icon: tag.type.typeIcon(),
                             name: tag.type.rawValue,
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
        TagsGroup()
    }
}
