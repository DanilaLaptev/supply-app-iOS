import SwiftUI
import Combine

struct OrganizationImageView: View {
    public static let tag = "OrganizationImageView"
    
    @StateObject var viewModel = OrganizationImageViewModel()
    
    @State private var isSharePresented = false
    @EnvironmentObject private var newOrganization: OrganizationCreationModel
    
    var body: some View {
        VStack {
            NavigationLink(
                "",
                destination: LocationView().environmentObject(newOrganization),
                isActive: $viewModel.navigateToLocationView
            )
            
            Header(title: "Фото организации")
            
            Spacer()
            
            SelectedImage()
                .padding(.bottom, 8)
                .onTapGesture {
                    isSharePresented.toggle()
                }
                .sheet(isPresented: $isSharePresented) {
                    PhotoPicker(selectedImage: $viewModel.selectedImage)
                }
            
            Spacer()
            
            CustomButton(label: Text("Сохранить")) {
                viewModel.uploadImage()
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .padding(.bottom, safeAreaEdgeInsets.bottom)
        .padding(.horizontal, 16)
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
    
    @ViewBuilder
    func SelectedImage() -> some View {
        ZStack(alignment: .center) {
            if let image = viewModel.selectedImage {
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            } else {
                Rectangle()
                    .foregroundColor(Color.customWhite)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Image.customImage
                    .frame(width: 40, height: 40)
                    .foregroundColor(.customOrange)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1 / 1, contentMode: .fit)
        .clipped()
        .cornerRadius(8)
    }
}

struct OrganizationImageViewView_Previews: PreviewProvider {
    @State static var data = OrganizationCreationModel()
    
    static var previews: some View {
        NavigationView {
            OrganizationImageView()
                .environmentObject(data)
        }
    }
}
