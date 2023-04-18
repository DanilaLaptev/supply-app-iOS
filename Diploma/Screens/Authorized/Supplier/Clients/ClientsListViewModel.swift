import Foundation
import SwiftUI
import Combine
import MapKit

class ClientsListViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var viewManager = ViewManager.shared
    
    @Published var organizations: [OrganizationModel] = []
    
    @Published var selectedProductTypes: [ProductType]? = nil
    @Published var distanceFromMe: Double? = nil
    @Published var suppliersList: [OrganizationModel] = []

    @Published var selectedMarker: MapMarker? = nil
    @Published var markers: [MapMarker] = []
    
    @Published var selectedOrganization: OrganizationModel? = nil
    
    private var markersPublisher: AnyPublisher<[MapMarker], Never> {
        $organizations
            .map { organizationModels -> [MapMarker] in
                organizationModels.map { organization in
                    let coordinate = CLLocationCoordinate2D(
                        latitude: organization.address.latitude,
                        longitude: organization.address.longitude
                    )
                    return MapMarker(name: organization.title, location: coordinate)
                }
            }.eraseToAnyPublisher()
    }
    
    init() {
        fetchOrganizations()
        
        markersPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] markers in
                self?.markers = markers
            }.store(in: &cancellableSet)
    }
    
    func setSelectedOrganization(_ organization: OrganizationModel) {
        selectedOrganization = organization
    }
    
    func fetchOrganizations() {
        viewManager.isLoading = true
        
        // TODO: request to fetch items
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in

            guard let self = self else { return }
            self.viewManager.isLoading = false
            
            self.organizations = [
                .test,
                OrganizationModel(title: "Brooklyn Bridge",
                                  organiztionImageUrl: "https://www.wanderlustchloe.com/wp-content/uploads/2021/07/Sydney-Harbour-Bridge-11.jpg",
                                  address: Address(addressName: "Brooklyn Bridge",
                                                   longitude: -74,
                                                   latitude: 40),
                                  storageItems: []
                                 ),
                OrganizationModel(title: "Golden Gate Bridge",
                                  organiztionImageUrl: "https://www.wanderlustchloe.com/wp-content/uploads/2021/07/Sydney-Harbour-Bridge-11.jpg",
                                  address: Address(addressName: "Golden Gate Bridge",
                                                   longitude: -122,
                                                   latitude: 37),
                                  storageItems: []
                                 ),
                .empty
            ]
        }
    }
}
