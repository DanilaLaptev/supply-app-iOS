import SwiftUI

struct ProfileScreen: View {
    public static let tag = "ProfileScreen"
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        VStack {
            CustomButton(label: Text("log out")) {
                authManager.clearData()
            }
                .padding(32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
