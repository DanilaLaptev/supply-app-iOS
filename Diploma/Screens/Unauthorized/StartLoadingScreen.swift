import SwiftUI

struct StartLoadingScreen: View {
    var body: some View {
        NavigationLink {
            SignInScreen()
        } label: {
            Text("Loading ...")
        }
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
