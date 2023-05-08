import SwiftUI

struct SupplyHeader: View {
    let supplyModel: SupplyModel

    private var headerInfo: (name: String, image: Image) {
        if supplyModel.statusHistory.contains(where: { $0.status == .approved}) {
            return ("Заказ одобрен", .customSuccessAlert)
        }
        
        if supplyModel.statusHistory.contains(where: { $0.status == .denied}) {
            return ("Заказ отклонён", .customErrorAlert)
        }
        
        return ("Заказ обрабатывается", .customInfoAlert)
    }
    
    
    var body: some View {
        HStack(spacing: 16) {
            headerInfo.image.frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(headerInfo.name).font(.customSubtitle)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.customWhite)
        .cornerRadius(8)
    }
}

struct SupplyHeader_Previews: PreviewProvider {
    static var previews: some View {
        SupplyHeader(supplyModel: .empty)
    }
}
