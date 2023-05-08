import SwiftUI

struct SupplierProductCard: View {
    @State private var showExtraOptions = false
    
    var model: StorageItemModel
    
    var tapCard: (()->())? = nil
    var tapEditingButton: (()->())? = nil
    var tapVisibilityButton: (()->())? = nil
    var tapDeletingButton: (()->())? = nil
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(model.product.name)
                    .font(.customSubtitle)
                    .foregroundColor(.customBlack)
                Text("\(Int(model.price)) ₽")
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
            ExtraOption(icon: model.isHidden ? Image.customClosedEye : .customEye, action: tapVisibilityButton),
            ExtraOption(icon: .customBin, action: tapDeletingButton)
        ])
        .frame(maxWidth: .infinity)
        .background(model.isHidden ? Color.customGray : .customWhite)
        .cornerRadius(8)
    }
}

struct SupplierProductCard_Previews: PreviewProvider {
    static var previews: some View {
        SupplierProductCard(model: .empty)
            .padding()
    }
}
