import SwiftUI

struct ProductScreen: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 8) {
                Header()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .foregroundColor(.customDarkGray)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                
                ExtendableSection {
                    Text("TODO")
                } headerContent: {
                    Text("Описание").font(.customSubtitle)
                }
                .padding(.horizontal, 16)
                
                ExtendableSection {
                    Text("TODO")
                } headerContent: {
                    Text("Состав").font(.customSubtitle)
                }
                .padding(.horizontal, 16)
                
                ExtendableSection {
                    Text("TODO")
                } headerContent: {
                    Text("Пищевая ценность").font(.customSubtitle)
                }
                .padding(.horizontal, 16)

            }
            .padding(.top, 8)
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .frame(maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .background(Color.customLightGray)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ProductScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductScreen()
    }
}
