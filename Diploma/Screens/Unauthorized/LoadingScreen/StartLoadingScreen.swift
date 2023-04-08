import SwiftUI

struct StartLoadingScreen: View {
    @StateObject var viewModel = LoadingScreenViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            NavigationLink("", destination: AuthorizationWrapper(), tag: AuthorizationWrapper.tag, selection: $viewModel.nextScreenTag)
            
            Spacer()

            Image("packed box")
                .resizable()
                .aspectRatio(1 / 1, contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
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
