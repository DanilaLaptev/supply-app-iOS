import SwiftUI

struct Loader: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .center) {
            Loader(isAnimating: .constant(true), style: .medium)
        }
    }
}
