import SwiftUI

struct SuppliersListFilterScreen: View {
    @EnvironmentObject private var viewModel: SuppliersListViewModel
    
    @Binding var selectedProductTypes: [ProductType]
    
    private var selectedTypesString: String {
        if selectedProductTypes.isEmpty { return "Все" }
        return selectedProductTypes.map { $0.name }.joined(separator: ", ")
    }
    
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
                        
                        BigTagsGroup(selectedTags: $selectedProductTypes)
                    }
                    .padding(.top, 8)
                } headerContent: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Доступная продукция").font(.customSubtitle)
                        Text(selectedTypesString).font(.customHint)
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
    @State static var vm = SupplierViewModel()
    static var previews: some View {
        SuppliersListFilterScreen(selectedProductTypes: .constant([]))
            .environmentObject(vm)
    }
}
