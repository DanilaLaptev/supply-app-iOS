import SwiftUI

// TODO: Map elements rewrite
struct SuppliersListScreen: View {
    @State var landmarks: [Landmark] = [
        Landmark(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
        Landmark(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
        Landmark(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
    ]
    
    @State var selectedLandmark: Landmark? = nil
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                MapView(landmarks: $landmarks,
                                    selectedLandmark: $selectedLandmark)

                    .frame(maxWidth: .infinity)
                    .frame(height: 320)
                
                HStack(spacing: 8) {
                    CustomTextField(icon: .customSearch, isDividerVisible: true, placeholder: "Поиск")
                    CustomButton(icon: .customFilter)
                        .frame(width: 48)
                }
                .padding(16)
                
                VStack {
                    ForEach((0...8), id: \.self) { _ in
                        StaticProductCard(name: "Название", price: 100, itemsNumber: 12)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 8)
        }
        .clipped()
        .background(Color.customLightGray)
    }
}

struct SuppliersScreen_Previews: PreviewProvider {
    static var previews: some View {
        SuppliersListScreen()
    }
}
