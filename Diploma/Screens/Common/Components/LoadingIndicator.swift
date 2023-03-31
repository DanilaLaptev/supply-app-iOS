import SwiftUI

struct LoadingIndicator: UIViewRepresentable {
    @Binding var isLoading: Bool
    var loaderStyle: UIActivityIndicatorView.Style = .medium

    func makeUIView(context: UIViewRepresentableContext<LoadingIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: loaderStyle)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingIndicator>) {
        isLoading ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .center) {
            LoadingIndicator(isLoading: .constant(true), loaderStyle: .medium)
        }
    }
}
