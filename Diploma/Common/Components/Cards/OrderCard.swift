import SwiftUI

struct OrderCard: View {
    var body: some View {
        HStack {
            Text("\(12) ₽")
                .font(.customStandard)
                .foregroundColor(.customBlack)
            Spacer()
            Text("\(12) ₽")
                .font(.customStandard)
                .foregroundColor(.customBlack)
        }
        .padding(16)
        .background(Color.customWhite)
        .cornerRadius(8)
        
    }
}

struct OrderCard_Previews: PreviewProvider {
    static var previews: some View {
        OrderCard()
    }
}
