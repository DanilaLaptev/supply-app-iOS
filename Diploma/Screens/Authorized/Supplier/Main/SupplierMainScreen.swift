import SwiftUI

struct SupplierMainScreen: View {
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach((0...16), id: \.self) { _ in
                        SmallTag(icon: .customClock, name: "tag")
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 8)
            .padding(.bottom, 16)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach((0...32), id: \.self) { _ in
                        NavigationLink {
                            ProductScreen()
                        } label: {
                            SupplierProductCard()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
    }
}

struct SupplierMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        SupplierMainScreen()
    }
}
