import SwiftUI

struct StaticProductCard: View {
    let name: String
    let price: Int
    let itemsNumber: Int

    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.customSubtitle)
                .foregroundColor(.customBlack)
            HStack {
                Text("\(price) ₽")
                    .font(.customStandard)
                    .foregroundColor(.customBlack)
                Spacer()
                Text("× \(itemsNumber)")
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
        StaticProductCard(name: "Название продукта", price: 220, itemsNumber: 15)
    }
}
