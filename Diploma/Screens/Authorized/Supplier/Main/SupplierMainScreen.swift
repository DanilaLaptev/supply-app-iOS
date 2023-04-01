import SwiftUI

struct SupplierMainScreen: View {
    public static let tag = "SupplierMainScreen"
    @State var showEditProductScreen = false
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var tagSelection: String? = nil
    
    var body: some View {
        VStack {
            NavigationLink("", destination: EditProductScreen(), tag: EditProductScreen.tag, selection: $tagSelection)
            NavigationLink("", destination: ProductScreen(), tag: ProductScreen.tag, selection: $tagSelection)
            
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
            tools.setBottomBarVisibility(true)
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
