import SwiftUI

struct ProductPicker: View {
    @Binding var selectedItem: ProductModel?
    var items: [ProductModel]
    @State private var searchText = ""

    var tapRefreshButton: (() -> ())?
    
    var filteredItems: [ProductModel] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            ExtendableSection {
                VStack {
                    HStack {
                        CustomButton(icon: .customFile).frame(width: 48)
                        
                        CustomTextField(textFieldValue: $searchText, placeholder: "Поиск")
                    }
                    
                    ScrollView {
                        VStack {
                            ForEach(filteredItems) { item in
                                HStack {
                                    Text(item.name).font(.customHint)
                                    Spacer()
                                    if selectedItem == item {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 16)
                                .background(Color.customWhite)
                                .cornerRadius(8)
                                .onTapGesture {
                                    selectedItem = item
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .frame(height: 160)
                }
            } headerContent: {
                Text("Продукт: \(selectedItem?.name ?? "-")").font(.customStandard)
            }
        }
    }
}

struct ProductPicker_Previews: PreviewProvider {
    static var previews: some View {
        ProductPicker(selectedItem: .constant(.empty), items: [])
    }
}
