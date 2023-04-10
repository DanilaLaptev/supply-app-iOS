import SwiftUI

// TODO: Map elements rewrite
struct SupplierClientsScreen: View {
    public static let tag = "SupplierClientsScreen"
    
    @State var landmarks: [MapMarker] = [
        MapMarker(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
        MapMarker(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
        MapMarker(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
    ]
    
    @State var selectedLandmark: MapMarker? = nil
    @State var showFilters = false
    @State var search = ""

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                MapView(markers: $landmarks,
                                    selectedMarker: $selectedLandmark)

                    .frame(maxWidth: .infinity)
                    .frame(height: 320)
                    .padding(.bottom, -8)
                
                BottomSheet {
                    VStack {
                        HStack(spacing: 8) {
                            CustomTextField(textFieldValue: $search, icon: .customSearch, isDividerVisible: true, placeholder: "Поиск")
                            CustomButton(icon: .customFilter) {
                                showFilters.toggle()
                            }
                            .frame(width: 48)
                        }
                        .padding(.bottom, 16)
                        
                        VStack {
                            ForEach((0...8), id: \.self) { _ in
                                StaticProductCard(storageItem: .empty)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                SuppliersListFilterScreen()
            }
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct SupplierClientsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierClientsScreen()
        }
    }
}
