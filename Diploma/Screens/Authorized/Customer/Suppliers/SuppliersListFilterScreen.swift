import SwiftUI

struct SuppliersListFilterScreen: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 8) {
                ExtendableSection {
                    VStack {
                        
                    }
                } headerContent: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Расстояние до меня").font(.customSubtitle)
                        Text("5 км").font(.customHint)
                    }
                }
                
                ExtendableSection {
                    VStack(spacing: 16) {
                        CustomTextField(textFieldValue: .constant(""), icon: .customSearch, isDividerVisible: true, placeholder: "Тип продукта")
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 8) {
                                ForEach((1...24), id: \.self) { _ in
                                    BigTag(icon: .customBox, name: "Выпечка")
                                }
                            }
                        }
                    }
                    .padding(.top, 8)
                } headerContent: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Доступная продукция").font(.customSubtitle)
                        Text("Напитки, выпечка").font(.customHint)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .padding(.top, 16)
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct SuppliersListFilterScreen_Previews: PreviewProvider {
    static var previews: some View {
        SuppliersListFilterScreen()
    }
}
