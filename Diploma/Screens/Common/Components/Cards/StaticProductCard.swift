import SwiftUI

struct StaticProductCard: View {
    let storageItem: StorageItemModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(storageItem.product.name)
                .font(.customSubtitle)
                .foregroundColor(.customBlack)
            HStack {
                Text("\(Int(storageItem.price)) ₽")
                    .font(.customStandard)
                    .foregroundColor(.customBlack)
                Spacer()
                Text("× \(storageItem.quantity)")
                    .font(.customStandard)
                    .foregroundColor(.customDarkGray)
            }
        }
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.customDarkGray, lineWidth: 1)
        )
        .background(Color.customWhite)
        .cornerRadius(8)
    }
}

struct StaticProductCard_Previews: PreviewProvider {
    static var previews: some View {
        StaticProductCard(storageItem: .empty)
    }
}
