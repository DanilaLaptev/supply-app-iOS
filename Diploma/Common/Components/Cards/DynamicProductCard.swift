import SwiftUI

struct DynamicProductCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Название продукта")
                .font(.customSubtitle)
                .foregroundColor(.customBlack)
            HStack {
                Text("0 ₽")
                    .font(.customHint)
                    .foregroundColor(.customDarkGray)
                Spacer()
                Counter()
            }
        }
        .padding(16)
        .background(Color.customWhite)
        .cornerRadius(8)
    }
}

struct DynamicProductCard_Previews: PreviewProvider {
    static var previews: some View {
        DynamicProductCard()
    }
}
