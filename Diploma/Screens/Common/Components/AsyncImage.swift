import SwiftUI
import Combine

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var imageLoader: ImageLoader
    private let placeholder: Placeholder
    
    init(imageUrl: URL?, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _imageLoader = ObservedObject(wrappedValue: ImageLoader(imageUrl: imageUrl))
    }
    
    var body: some View {
        if let image = imageLoader.image {
            GeometryReader { geometry in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        } else {
            placeholder
                .onAppear {
                    imageLoader.load()
                }
        }
    }
}

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    
    private let imageUrl: URL?
    private var cancellable: AnyCancellable?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
        load()
    }
    
    func load() {
        guard let imageUrl else {
            Debugger.shared.printLog("image url is nil")
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: imageUrl)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AsyncImage(imageUrl: URL(string: "https://www.reduceimages.com/img/new-icon.png")) {
                Color.customDarkGray
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}
