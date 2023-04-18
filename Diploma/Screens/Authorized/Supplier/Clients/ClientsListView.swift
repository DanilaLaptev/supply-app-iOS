import SwiftUI

// TODO: Map elements rewrite
struct ClientsListView: View {
    public static let tag = "ClientsListView"
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var tagSelection: String? = nil
    @StateObject var viewModel = SuppliersListViewModel()
    
    @State private var showFilters = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                NavigationLink("", destination: SupplierView(organizationModel: viewModel.selectedOrganization ?? .empty), tag: SupplierView.tag, selection: $tagSelection)

                
                VStack(alignment: .leading, spacing: 0) {
                    MapView(markers: $viewModel.markers,
                            selectedMarker: $viewModel.selectedMarker)
                    .frame(maxWidth: .infinity)
                    .frame(height: geo.size.height * 0.56)
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
                                    OrganizationCard(organizationModel: organization)
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
}

struct ClientsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ClientsListView()
        }
    }
}
