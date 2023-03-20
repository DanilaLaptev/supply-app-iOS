import SwiftUI

struct MainScreen: View {
    public static let tag = "MainScreen"
    
    @EnvironmentObject private var tools: ViewTools
    
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
                            DynamicProductCard()
                        }
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

struct MainScreen_Previews: PreviewProvider {
    @StateObject static var viewTools = ViewTools()
    
    static var previews: some View {
        NavigationView {
            MainScreen()
                .environmentObject(viewTools)
        }
    }
}
