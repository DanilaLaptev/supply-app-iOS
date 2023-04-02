import SwiftUI

struct MainScreen: View {
    public static let tag = "MainScreen"
    
    
    @StateObject private var tools = ViewManager.shared
    
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
            self.tools.bottomBarIsVisible = true
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainScreen()
        }
    }
}
