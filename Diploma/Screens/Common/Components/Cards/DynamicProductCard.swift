import SwiftUI

struct DynamicProductCard: View {
    var model: StorageItemModel
    var extraOptions: [ExtraOption]
    
    @State var selectedNumber = 0
    
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
                Text("\(model.price) ₽")
                    .font(.customHint)
                    .foregroundColor(.customDarkGray)
                Spacer()
                Counter(counterValue: $selectedNumber)
            }
        }
        .padding(16)
        .background(Color.customWhite)
    }
}

struct DynamicProductCard_Previews: PreviewProvider {
    static var previews: some View {
        DynamicProductCard(model: .empty, extraOptions: []).padding()
        DynamicProductCard(model: .empty, extraOptions: [
            ExtraOption(icon: .customBox)
        ]).padding()
    }
}
