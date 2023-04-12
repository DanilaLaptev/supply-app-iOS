import SwiftUI

struct SupplierMainScreen: View {
    public static let tag = "SupplierMainScreen"
    @State var showEditProductScreen = false
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var tagSelection: String? = nil
    
    var body: some View {
        VStack {
            NavigationLink("", destination: EditProductScreen(), tag: EditProductScreen.tag, selection: $tagSelection)
            NavigationLink("", destination: ProductScreen(model: .empty), tag: ProductScreen.tag, selection: $tagSelection)
            
            TagsGroup<ProductType>()
            .padding(.top, 8)
            .padding(.bottom, 16)
            ScrollView(.vertical, showsIndicators: false) {
                AddProductButton  {
                    tagSelection = EditProductScreen.tag
                    
                }
                .padding(.horizontal, 16)
                
                VStack {
                    ForEach((0...32), id: \.self) { _ in
                        SupplierProductCard {
                            tagSelection = EditProductScreen.tag
                        } tapDeletingButton: {
                            // TODO:
                        }
                        .onTapGesture { tagSelection = ProductScreen.tag }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = true
        }
    }
}

struct SupplierMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierMainScreen()
        }
    }
}
