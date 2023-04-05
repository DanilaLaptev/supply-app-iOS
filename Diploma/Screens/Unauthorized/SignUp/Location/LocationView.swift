import SwiftUI

struct LocationView: View {
    public static let tag = "LocationScreen"
    
    @State private var tagSelection: String? = nil
    
    @StateObject private var tools = ViewManager.shared
    @StateObject private var alertManager = AlertManager.shared
    
    @EnvironmentObject private var newOrganizationData: OrganizationCreationModel
    
    @State var landmarks: [Landmark] = [
        Landmark(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
        Landmark(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
        Landmark(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
    ]
    
    @State var selectedLandmark: Landmark? = nil
    @State private var counter = 0 // TODO: remove counter
    
    @Environment(\.presentationMode) private var presentation

    var body: some View {
        OverflowScroll {
            VStack(spacing: 0) {
                MapView(landmarks: $landmarks,
                        selectedLandmark: $selectedLandmark)
                
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(.bottom, -4)
                
                BottomSheet {
                    VStack(alignment: .leading, spacing: 8) {
                        Header(title: "Адрес")
                        
                        CustomTextField(textFieldValue: .constant(""), placeholder: "Адрес организации")
                            .padding(.bottom, 24)
                        
                        NavigationLink(destination: MainScreen(), tag: MainScreen.tag, selection: $tagSelection) {
                            CustomButton(label: Text("Завершить регистрацию")) {
                                counter += 1
                                alertManager.showAlert(AlertModel(type: .error, description: "description \(counter)"))
                            }
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