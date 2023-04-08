import SwiftUI

struct LoaderView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .center) {
                LoadingIndicator(isLoading: $isLoading, loaderStyle: .medium)
            }
            .padding(16)
            .background(Color.customLightOrange)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customDarkGray.opacity(0.2))
        .edgesIgnoringSafeArea(.all)
        .opacity(isLoading ? 1 : 0)
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView(isLoading: .constant(true))
    }
}
