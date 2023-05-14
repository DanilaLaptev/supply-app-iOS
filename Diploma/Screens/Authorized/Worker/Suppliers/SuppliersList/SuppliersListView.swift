import SwiftUI

struct SuppliersListView: View {
    public static let tag = "SuppliersListView"
    
    @StateObject private var tools = ViewManager.shared
    
    @StateObject var viewModel = SuppliersListViewModel()
    
    @State private var showFilters = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                NavigationLink(
                    destination: SupplierView(organizationModel: viewModel.selectedOrganization ?? .empty),
                    isActive: $viewModel.navigateToOrganizationView,
                    label: { }
                )
                
                VStack(alignment: .leading, spacing: 0) {
                    MapView(markers: $viewModel.markers,
                            selectedMarker: $viewModel.selectedMarker)
                    .frame(maxWidth: .infinity)
                    .frame(height: geo.size.height * 0.56)
                    .padding(.bottom, -8)
                    
                    BottomSheet(background: .customLightGray) {
                        VStack {
                            HStack(spacing: 8) {
                                CustomButton(icon: .customReload, isCircleShape: true) {
                                    viewModel.refreshData()
                                }
                                .frame(width: 48)
                                
                                CustomTextField(textFieldValue: $viewModel.organizationNameFilter, icon: .customSearch, isDividerVisible: true, placeholder: "Поиск", background: .customWhite)
                                CustomButton(icon: .customFilter) {
                                    showFilters.toggle()
                                }
                                .frame(width: 48)
                            }
                            .padding(.bottom, 16)
                            
                            VStack {
                                ForEach(viewModel.organizations) { organization in
                                    OrganizationCard(organizationModel: organization)
                                        .onTapGesture {
                                            viewModel.selectedOrganization = organization
                                        }
                                        .onAppear {
                                            if viewModel.organizations.last?.id == organization.id {
                                                viewModel.fetchOrganizations()
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .sheet(isPresented: $showFilters) {
                    SuppliersListFilterScreen(selectedProductTypes: $viewModel.organizationProductTypes)
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

struct SuppliersScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SuppliersListView()
        }
    }
}
