import SwiftUI

struct SupplierProductCard: View {
    @State private var showExtraOptions = false
    var tapCard: (()->())? = nil
    var tapEditingButton: (()->())? = nil
    var tapVisibilityButton: (()->())? = nil
    var tapDeletingButton: (()->())? = nil
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Название продукта")
                    .font(.customSubtitle)
                    .foregroundColor(.customBlack)
                Text("0 ₽")
                    .font(.customHint)
                    .foregroundColor(.customDarkGray)
            }
            Spacer()
        }
        .padding([.leading, .top, .bottom] , 16)
        .padding(.trailing , 40)
        .onTapGesture {
            tapCard?()
        }
        .extraOptions([
            ExtraOption(icon: .customPencil, action: tapEditingButton),
            ExtraOption(icon: .customEye, action: tapVisibilityButton),
            ExtraOption(icon: .customBin, action: tapDeletingButton)
        ])
        .frame(maxWidth: .infinity)
        .background(Color.customWhite)
        .cornerRadius(8)
    }
}

struct SupplierProductCard_Previews: PreviewProvider {
    static var previews: some View {
        SupplierProductCard()
            .padding()
    }
}
