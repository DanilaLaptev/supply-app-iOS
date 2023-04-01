import SwiftUI

struct LoaderView: View {
    @State var loading = true
    var body: some View {
        ZStack(alignment: .center) {
            LoadingIndicator(isLoading: $loading, loaderStyle: .medium)
        }
        .padding(16)
        .background(Color.customGray.opacity(0.6))
        .cornerRadius(8)
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
