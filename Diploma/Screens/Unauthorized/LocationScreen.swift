import SwiftUI

struct LocationScreen: View {
    @State var landmarks: [Landmark] = [
        Landmark(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
        Landmark(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
        Landmark(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
    ]
    
    @State var selectedLandmark: Landmark? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            MapView(landmarks: $landmarks,
                                selectedLandmark: $selectedLandmark)

                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(.bottom, -4)
            
            BottomSheet {
                VStack(alignment: .leading, spacing: 8) {
                    Header()
                    
                    CustomTextField(placeholder: "Адрес организации")
                        .padding(.bottom, 24)
                    
                    CustomButton(label: Text("Завершить регистрацию"))
                }
            }
        }
        .background(Color.customLightGray)
    }
}

struct LocationScreen_Previews: PreviewProvider {
    static var previews: some View {
        LocationScreen()
    }
}
