import SwiftUI

struct StartLoadingScreen: View {
    @StateObject var viewModel = LoadingScreenViewModel()

    var body: some View {
        ZStack(alignment: .center) {
            NavigationLink("", destination: AuthorizationWrapper(), tag: AuthorizationWrapper.tag, selection: $viewModel.nextScreenTag)
            
            Text("Loading ...")
        }
        .defaultScreenSettings()
        .onAppear {
            viewModel.checkUserAuth()
        }
    }
}

struct StartLoadingScreen_Previews: PreviewProvider {
    @StateObject static var tools = ViewTools()
    static var previews: some View {
        NavigationView {
            StartLoadingScreen()
                .environmentObject(tools)
        }
    }
}
