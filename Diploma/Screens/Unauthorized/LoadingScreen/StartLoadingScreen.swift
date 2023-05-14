import SwiftUI

struct StartLoadingScreen: View {
    @StateObject var viewModel = LoadingScreenViewModel()
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: AuthorizationWrapper(),
                isActive: $viewModel.navigateToAuthWrapper,
                label: { }
            )
            
            Spacer()
            Image("box loading")
                .resizable()
                .aspectRatio(1 / 1, contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.7)
            HStack(spacing: 16) {
                CustomTextField(textFieldValue: $viewModel.ipFieldValue, placeholder: "current ip")
                CustomButton(icon: .customBox) {
                    viewModel.setBaseUrl()
                    viewModel.checkUserAuth()
                }
                .frame(width: 48)
            }
            
            LoadingIndicator(isLoading: $viewModel.isLoading)
                .padding(.top, UIScreen.main.bounds.width * 0.8)
                .padding(.top, 32)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customLightOrange)
        .defaultScreenSettings()
    }
}

struct StartLoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StartLoadingScreen()
        }
    }
}
