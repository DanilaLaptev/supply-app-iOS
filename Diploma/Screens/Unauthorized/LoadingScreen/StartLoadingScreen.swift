import SwiftUI

struct StartLoadingScreen: View {
    @StateObject var viewModel = LoadingScreenViewModel()
    
    var body: some View {
        ZStack(alignment: .center) {
            NavigationLink(
                destination: AuthorizationWrapper(),
                isActive: $viewModel.navigateToAuthWrapper,
                label: { }
            )
            
            Image("box loading")
                .resizable()
                .aspectRatio(1 / 1, contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.7)
            
            LoadingIndicator(isLoading: $viewModel.isLoading)
                .padding(.top, UIScreen.main.bounds.width * 0.8)
                .padding(.top, 32)
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
