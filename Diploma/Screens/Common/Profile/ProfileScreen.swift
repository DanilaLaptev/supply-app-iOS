import SwiftUI

struct ProfileScreen: View {
    public static let tag = "ProfileScreen"
    
    var body: some View {
        VStack {
            Text("Profile!")
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
