import SwiftUI

struct LoaderView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            LoadingIndicator(isLoading: $isLoading, loaderStyle: .medium)
        }
        .padding(16)
        .background(Color.customDarkGray.opacity(0.6))
        .cornerRadius(8)
        .opacity(isLoading ? 1 : 0)
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView(isLoading: .constant(true))
    }
}
