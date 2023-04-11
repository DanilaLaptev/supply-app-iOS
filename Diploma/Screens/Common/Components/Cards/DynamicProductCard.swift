import SwiftUI

struct DynamicProductCard: View {
    var model: StorageItemModel
    var minimumQuantity = 0
    var maximumQuantity = 100
    
    var extraOptions: [ExtraOption]
    
    @Binding var selectedNumber: Int
    
    var body: some View {
        if extraOptions.isEmpty {
            Content()
                .cornerRadius(8)
        } else {
            Content()
                .extraOptions(extraOptions)
                .cornerRadius(8)
        }
    }
    
    func Content() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.product.name)
                .font(.customSubtitle)
                .foregroundColor(.customBlack)
            HStack {
                Text("\(Int(model.price)) ₽")
                    .font(.customHint)
                    .foregroundColor(.customDarkGray)
                Spacer()
                Counter(counterValue: $selectedNumber,
                        minimum: minimumQuantity,
                        maximum: maximumQuantity)
            }
        }
        .padding(16)
        .background(Color.customWhite)
    }
}

struct DynamicProductCard_Previews: PreviewProvider {
    static var previews: some View {
        DynamicProductCard(model: .empty, extraOptions: [], selectedNumber: .constant(0)).padding()
        DynamicProductCard(model: .empty, extraOptions: [
            ExtraOption(icon: .customBox)
        ], selectedNumber: .constant(0)).padding()
    }
}
