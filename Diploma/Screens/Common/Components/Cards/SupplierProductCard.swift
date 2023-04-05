import SwiftUI

struct SupplierProductCard: View {
    @State private var showExtraOptions = false
    var tapCard: (()->())? = nil
    var tapEditingButton: (()->())? = nil
    var tapDeletingButton: (()->())? = nil

    var body: some View {
        HStack {
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
            .overlay(
                HStack {
                    Spacer()
                    HStack(spacing: 8) {
                        CustomButton(icon: .customExtra, background: .clear, foreground: .customOrange) {
                            withAnimation {
                                showExtraOptions.toggle()
                            }
                        }
                        .frame(width: 24, height: 24)
                        
                        HStack(spacing: 8) {
                            CustomButton(icon: .customPencil, background: .customOrange, foreground: .customWhite, isCircleShape: true) {
                                showExtraOptions.toggle()
                                tapEditingButton?()
                            }
                            .frame(width: 48, height: 48)
                            
                            CustomButton(icon: .customEye, background: .customOrange, foreground: .customWhite, isCircleShape: true) {
                            }
                            .frame(width: 48, height: 48)
                            
                            CustomButton(icon: .customBin, background: .customOrange, foreground: .customWhite, isCircleShape: true) {
                                showExtraOptions.toggle()
                                tapDeletingButton?()
                            }
                            .frame(width: 48, height: 48)
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
                    .background(Color.customLightOrange)
                    .frame(maxHeight: .infinity)
                    .offset(x: showExtraOptions ? 0 : 172)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
        }
        .frame(maxWidth: .infinity)
        .background(Color.customWhite)
        .cornerRadius(8)
        .clipped()
    }
}

struct SupplierProductCard_Previews: PreviewProvider {
    static var previews: some View {
        SupplierProductCard()
            .padding()
    }
}
