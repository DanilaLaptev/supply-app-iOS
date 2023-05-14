import Foundation
import SwiftUI
import Combine
import MapKit


class ClientsListViewModel: ObservableObject {
    private let organizationService: OrganizationServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var viewManager = ViewManager.shared
    
    @Published var organizations: [OrganizationModel] = []
    
    @Published var suppliersList: [OrganizationBranchModel] = []
    
    @Published var selectedMarker: MapMarker? = nil
    @Published var markers: [MapMarker] = []
    
    @Published var selectedOrganization: OrganizationModel? = nil
    
    @Published var organizationNameFilter: String = ""
    
    private var page = 0
    private let perPage = 10
    
    private var markersPublisher: AnyPublisher<[MapMarker], Never> {
        $organizations
            .map { organizationModels -> [MapMarker] in
                organizationModels.map { organization in
                    let coordinate = CLLocationCoordinate2D(
                        latitude: organization.branches.last?.address?.latitude ?? 0,
                        longitude: organization.branches.last?.address?.longitude ?? 0
                    )
                    return MapMarker(name: organization.title ?? "None", location: coordinate)
                }
            }.eraseToAnyPublisher()
    }
    
    private var updateFiltersPublisher: AnyPublisher<Void, Never> {
        $organizationNameFilter
            .removeDuplicates()
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .map { _ in () }.eraseToAnyPublisher()
    }
    
    init(organizationService: OrganizationServiceProtocol = OrganizationService()) {
        self.organizationService = organizationService
        fetchOrganizations()
        
        setupBindings()
    }
    
    private func setupBindings() {
        markersPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] markers in
                self?.markers = markers
            }.store(in: &cancellableSet)
        
        updateFiltersPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] markers in
                self?.refreshData()
            }.store(in: &cancellableSet)
    }
    
    func setSelectedOrganization(_ organization: OrganizationModel) {
        selectedOrganization = organization
    }
    
    func fetchOrganizations() {
        guard page != -1 else {
            return
        }
        
        let filter = FilterDto(
            role: .worker,
            title: organizationNameFilter,
            page: page,
            perPage: 20
        )
        
        organizationService.getOrganizations(filter: filter) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self,
                      let total = response.total else {
                    AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                    return
                }
                let receivedOrganizations = response.items.map { item -> OrganizationModel in
                    OrganizationModel.from(item)
                }
                
                self.organizations += receivedOrganizations
                self.page = total > self.organizations.count ? self.page + 1 : -1
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
    
    func refreshData() {
        page = 0
        organizations = []
        fetchOrganizations()
    }
}
