import SwiftUI

struct StartLoadingScreen: View {
    @StateObject var viewModel = LoadingScreenViewModel()
    
    var body: some View {
        ZStack(alignment: .center) {
            NavigationLink("", destination: AuthorizationWrapper(), tag: AuthorizationWrapper.tag, selection: $viewModel.nextScreenTag)
            
            Spacer()

            Image("packed box")
                .resizable()
                .aspectRatio(1 / 1, contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.5)
            
            LoadingIndicator(isLoading: $viewModel.isLoading)
                .padding(.top, UIScreen.main.bounds.width * 0.5)
                .padding(.top, 16)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customLightOrange)
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
