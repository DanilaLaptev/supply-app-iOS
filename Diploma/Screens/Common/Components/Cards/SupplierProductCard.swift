import SwiftUI

struct SupplierProductCard: View {
    @State private var showExtraOptions = false
    var tapEditingButton: (()->())? = nil
    var tapDeletingButton: (()->())? = nil
    
    var body: some View {
        ZStack(alignment: .trailing) {
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
            
            HStack(spacing: 8) {
                CustomButton(icon: .customExtra, background: .clear, foreground: .customOrange) {
                    withAnimation {
                        showExtraOptions.toggle()
                    }
                }
                .frame(width: 24, height: 24)
                
                HStack(spacing: 8) {
                    CustomButton(icon: .customBox, background: .customOrange, foreground: .customWhite, isCircleShape: true) {
                        showExtraOptions.toggle()
                        tapEditingButton?()
                    }
                    .frame(width: 48)
                    .frame(maxHeight: .infinity)
                    
                    CustomButton(icon: .customMinus, background: .customOrange, foreground: .customWhite, isCircleShape: true) {
                        showExtraOptions.toggle()
                        tapDeletingButton?()
                    }
                    .frame(width: 48)
                    .frame(maxHeight: .infinity)
                }
            }
            .padding(12)
            .frame(maxHeight: .infinity)
            .background(Color.customLightOrange)
            .offset(x: showExtraOptions ? 0 : 116)
        }
        .frame(height: nil)
        .background(Color.customWhite)
        .cornerRadius(8)
        .clipped()
    }
}

struct SupplierProductCard_Previews: PreviewProvider {
    static var previews: some View {
        SupplierProductCard()
    }
}