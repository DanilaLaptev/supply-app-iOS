import SwiftUI

// TODO: Map elements rewrite
struct SupplierClientsScreen: View {
    public static let tag = "SupplierClientsScreen"
    
    @State var landmarks: [Landmark] = [
        Landmark(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
        Landmark(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
        Landmark(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
    ]
    
    @State var selectedLandmark: Landmark? = nil
    @State var showFilters = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                MapView(landmarks: $landmarks,
                                    selectedLandmark: $selectedLandmark)

                    .frame(maxWidth: .infinity)
                    .frame(height: 320)
                    .padding(.bottom, -8)
                
                BottomSheet {
                    VStack {
                        HStack(spacing: 8) {
                            CustomTextField(textFieldValue: .constant(""), icon: .customSearch, isDividerVisible: true, placeholder: "Поиск")
                            CustomButton(icon: .customFilter) {
                                showFilters.toggle()
                            }
                            .frame(width: 48)
                        }
                        .padding(.bottom, 16)
                        
                        VStack {
                            ForEach((0...8), id: \.self) { _ in
                                StaticProductCard(name: "Название", price: 100, itemsNumber: 12)
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
