import SwiftUI

struct ClientsListView: View {
    public static let tag = "ClientsListView"
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var tagSelection: String? = nil
    @StateObject var viewModel = ClientsListViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                NavigationLink(
                    "",
                    destination: SupplierView(organizationModel: viewModel.selectedOrganization ?? .empty),
                    tag: SupplierView.tag,
                    selection: $tagSelection
                )
                
                VStack(alignment: .leading, spacing: 0) {
                    MapView(markers: $viewModel.markers,
                            selectedMarker: $viewModel.selectedMarker)
                    .frame(maxWidth: .infinity)
                    .frame(height: geo.size.height * 0.56)
                    .padding(.bottom, -8)
                    
                    BottomSheet(background: .customLightGray) {
                        VStack {
                            HStack(alignment: .center) {
                                CustomButton(icon: .customReload, isCircleShape: true) {
                                    viewModel.refreshData()
                                }
                                .frame(width: 48)
                                CustomTextField(textFieldValue: $viewModel.organizationNameFilter, icon: .customSearch, isDividerVisible: true, placeholder: "Поиск", background: .customWhite)
                            }
                            .padding(.bottom, 16)
                            
                            VStack {
                                ForEach(viewModel.organizations) { organization in
                                    OrganizationCard(organizationModel: organization)
                                        .onTapGesture {
                                            AlertManager.shared.showAlert(.init(type: .info, description: "Вы не можете просматривать точки питания"))
                                        }
                                }
                            }
                        }
                    }
                }
                .frame(maxHeight: .infinity)
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
