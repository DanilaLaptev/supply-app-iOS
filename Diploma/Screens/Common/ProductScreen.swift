import SwiftUI

struct ProductScreen: View {
    public static let tag = "ProductScreen"
    
    @StateObject private var tools = ViewManager.shared
    
    let model: StorageItemModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 8) {
                Header(title: model.product.name)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                AsyncImage(imageUrl: URL(string: model.imageUrl)) {
                    Color.customDarkGray
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                ExtendableSection(isCollapsed: false) {
                    Text(model.description)
                } headerContent: {
                    Text("Описание").font(.customSubtitle)
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 8)
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = false
        }
    }
}

struct ProductScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductScreen(model: .empty)
        }
    }
}
