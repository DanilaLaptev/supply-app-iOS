import SwiftUI

struct SupplyCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("№ \(123)")
                        .font(.customSubtitle)
                        .foregroundColor(.customBlack)
                    Spacer()
                    Text("статус")
                        .font(.customHint)
                        .foregroundColor(.customBlack)
                }
                Text("Время доставки")
                    .font(.customStandard)
                    .foregroundColor(.customDarkGray)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.customWhite)
        .cornerRadius(8)
    }
}

struct SupplyCard_Previews: PreviewProvider {
    static var previews: some View {
        SupplyCard()
    }
}
