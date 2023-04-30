import SwiftUI

struct LocationView: View {
    public static let tag = "LocationScreen"
    
    @State private var tagSelection: String? = nil
    
    @StateObject private var tools = ViewManager.shared
    @StateObject private var alertManager = AlertManager.shared
    
    @StateObject private var viewModel = LocationViewModel()
    
    @EnvironmentObject private var newOrganization: OrganizationCreationModel
    
    @Environment(\.presentationMode) private var presentation

    var body: some View {
        OverflowScroll {
            NavigationLink("", destination: SignInView(), tag: SignInView.tag, selection: $tagSelection)
            
            VStack(spacing: 0) {
                MapView(markers: $viewModel.landmarks,
                        selectedMarker: $viewModel.selectedLandmark)
                
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(.bottom, -4)
                
                BottomSheet {
                    VStack(alignment: .leading, spacing: 8) {
                        Header(title: "Адрес")
                        
                        CustomTextField(textFieldValue: $viewModel.addressName, placeholder: "Адрес организации")
                            .padding(.bottom, 24)
                        
                        CustomButton(label: Text("Завершить регистрацию")) {
                            tagSelection = SignInView.tag
                        }
                    }
                }
            }
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.viewModel.setupOrganization(self.newOrganization)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    @State static var data = OrganizationCreationModel()
    
    static var previews: some View {
        NavigationView {
            LocationView()
                .environmentObject(data)
        }
    }
}
