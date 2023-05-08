import SwiftUI

struct RadioButtonGroup<Item: RadioGroupItem>: View {
    let items: [Item]
    @Binding var selected: Item?

    var body: some View {
        ForEach(items) { item in
            HStack(alignment: .top) {
                RadioButton(selected: item == selected)
                Text(item.name).font(.customStandard)
            }
            .onTapGesture {
                selected = item
            }
        }
    }
}
