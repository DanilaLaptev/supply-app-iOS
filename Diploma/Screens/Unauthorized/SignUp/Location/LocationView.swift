import SwiftUI

struct LocationView: View {
    public static let tag = "LocationScreen"
    
    @State private var tagSelection: String? = nil
    
    @StateObject private var tools = ViewManager.shared
    @StateObject private var alertManager = AlertManager.shared
    
    @EnvironmentObject private var newOrganizationData: OrganizationCreationModel
    
    @State var landmarks: [MapMarker] = [
        MapMarker(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
        MapMarker(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
        MapMarker(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
    ]
    
    @State var selectedLandmark: MapMarker? = nil
    @State private var counter = 0 // TODO: remove counter
    
    @Environment(\.presentationMode) private var presentation

    var body: some View {
        OverflowScroll {
            NavigationLink("", destination: SignInView(), tag: SignInView.tag, selection: $tagSelection)
            
            VStack(spacing: 0) {
                MapView(markers: $landmarks,
                        selectedMarker: $selectedLandmark)
                
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(.bottom, -4)
                
                BottomSheet {
                    VStack(alignment: .leading, spacing: 8) {
                        Header(title: "Адрес")
                        
                        CustomTextField(textFieldValue: .constant(""), placeholder: "Адрес организации")
                            .padding(.bottom, 24)
                        
                        CustomButton(label: Text("Завершить регистрацию")) {
                            counter += 1
                            alertManager.showAlert(AlertModel(type: .error, description: "description \(counter)"))
                            tagSelection = SignInView.tag
                        }
                    }
                }
            }
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct LocationScreen_Previews: PreviewProvider {
    @State static var data = OrganizationCreationModel()
    
    static var previews: some View {
        NavigationView {
            LocationView()
                .environmentObject(data)
        }
    }
}
