import SwiftUI

struct ProductScreen: View {
    public static let tag = "ProductScreen"
    @EnvironmentObject private var tools: ViewTools
    
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
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            tools.setBottomBarVisibility(false)
        }
    }
}

struct ProductScreen_Previews: PreviewProvider {
    @StateObject static var viewTools = ViewTools()
    
    static var previews: some View {
        NavigationView {
            ProductScreen()
                .environmentObject(viewTools)
        }
    }
}
