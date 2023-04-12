import SwiftUI

struct SupplyCard: View {
    let supplyModel: SupplyModel
    
    private var deliveryTime: String {
        DateFormatManager.shared.getFormattedString(supplyModel.deliveryTime, dateFormat: "d MMMM HH:mm")
    }
    
    private var created: String {
        DateFormatManager.shared.getFormattedString(supplyModel.created, dateFormat: "d MMM yyyy")
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("№ \(supplyModel.publicId)")
                        .font(.customSubtitle)
                        .foregroundColor(.customBlack)
                    Spacer()
                    Text(supplyModel.statusHistory.first?.status.name ?? "none")
                        .font(.customHint)
                        .foregroundColor(.customBlack)
                }
                Text("Доставка: \(deliveryTime)")
                    .font(.customStandard)
                    .foregroundColor(.customBlack)
                Text("Создан: \(created)")
                    .font(.customHint)
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
        SupplyCard(supplyModel: .empty)
    }
}
