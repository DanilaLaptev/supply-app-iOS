import SwiftUI

struct WorkerMainView: View {
    public static let tag = "WorkerMainView"
    
    @StateObject private var tools = ViewManager.shared
    @StateObject private var viewModel = WorkerMainViewModel()

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    SmallTag(icon: .customBox, name: "Все")
                    ForEach(viewModel.tags, id: \.self) { tag in
                        SmallTag(icon: .customClock, name: tag.rawValue)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 8)
            .padding(.bottom, 16)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(viewModel.storageItems) { storageItem in
                        NavigationLink {
                            ProductScreen(model: .empty)
                        } label: {
                            DynamicProductCard(model: storageItem, extraOptions: [
                                ExtraOption(icon: .customPencil, action: {}),
                                ExtraOption(icon: .customEye, action: {})
                            ])
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
            WorkerMainView()
        }
    }
}
