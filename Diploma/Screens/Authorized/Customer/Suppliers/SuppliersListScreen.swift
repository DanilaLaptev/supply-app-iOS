import SwiftUI

// TODO: Map elements rewrite
struct SuppliersListScreen: View {
    public static let tag = "SuppliersListScreen"
    
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var tagSelection: String? = nil

    
    @State var landmarks: [Landmark] = [
        Landmark(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
        Landmark(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
        Landmark(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
    ]
    
    @State private var selectedLandmark: Landmark? = nil
    @State private var showFilters = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                MapView(landmarks: $landmarks,
                                    selectedLandmark: $selectedLandmark)

                    .frame(maxWidth: .infinity)
                    .frame(height: 320)
                    .padding(.bottom, -8)
                
                BottomSheet(background: .customLightGray) {
                    VStack {
                        HStack(spacing: 8) {
                            CustomTextField(textFieldValue: .constant(""), icon: .customSearch, isDividerVisible: true, placeholder: "Поиск", background: .customWhite)
                            CustomButton(icon: .customFilter) {
                                showFilters.toggle()
                            }
                            .frame(width: 48)
                        }
                        .padding(.bottom, 16)
                        
                        VStack {
                            ForEach((0...8), id: \.self) { _ in
                                NavigationLink(destination: SupplierScreen(), tag: SupplierScreen.tag, selection: $tagSelection) {
                                    OrganizationCard(organizationModel: .empty)
                                        .onTapGesture {
                                            tagSelection = SupplierScreen.tag
                                        }
                                }
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
        .onAppear {
            self.tools.bottomBarIsVisible = true
        }
    }
}

struct SuppliersScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SuppliersListScreen()
        }
    }
}
