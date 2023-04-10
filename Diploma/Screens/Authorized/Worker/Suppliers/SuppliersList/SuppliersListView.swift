import SwiftUI

// TODO: Map elements rewrite
struct SuppliersListView: View {
    public static let tag = "SuppliersListView"
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var tagSelection: String? = nil
    @StateObject var viewModel = SuppliersListViewModel()
    
    @State private var showFilters = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                MapView(markers: $viewModel.markers,
                        selectedMarker: $viewModel.selectedMarker)
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
                            ForEach(viewModel.organizations) { organization in
                                NavigationLink(destination: SupplierView(organizationModel: organization), tag: SupplierView.tag, selection: $tagSelection) {
                                    OrganizationCard(organizationModel: organization)
                                        .onTapGesture {
                                            tagSelection = SupplierView.tag
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .sheet(isPresented: $showFilters) {
                SuppliersListFilterScreen()
                    .environmentObject(viewModel)
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
            SuppliersListView()
        }
    }
}
