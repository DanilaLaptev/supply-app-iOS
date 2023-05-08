import SwiftUI
import Combine

struct OrganizationImageView: View {
    public static let tag = "OrganizationImageView"
    
    @StateObject var viewModel = OrganizationImageViewModel()
    
    var body: some View {
        VStack {
            
        }
    }
    
//    @ViewBuilder
//    func SelectedImage() -> some View {
//        ZStack(alignment: .center) {
//            if let image = selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFill()
//            } else {
//                Rectangle()
//                    .foregroundColor(Color.customWhite)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                
//                Image.customImage
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(.customOrange)
//            }
//        }
//        .frame(height: 200)
//        .frame(maxWidth: .infinity)
//        .clipped()
//        .cornerRadius(8)
//    }
}

struct OrganizationImageViewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrganizationImageView()
        }
    }
}
