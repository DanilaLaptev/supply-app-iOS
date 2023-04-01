import SwiftUI

struct StartLoadingScreen: View {
    @StateObject var viewModel = LoadingScreenViewModel()
    
    var body: some View {
        ZStack(alignment: .center) {
            NavigationLink("", destination: AuthorizationWrapper(), tag: AuthorizationWrapper.tag, selection: $viewModel.nextScreenTag)
            
            LoaderView(loading: viewModel.isLoading)
        }
        .defaultScreenSettings()
        .onAppear {
            viewModel.checkUserAuth()
        }
    }
}

struct StartLoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StartLoadingScreen()
        }
    }
}
