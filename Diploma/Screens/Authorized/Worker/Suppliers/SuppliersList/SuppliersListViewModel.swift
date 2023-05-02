import Foundation
import SwiftUI
import Combine
import MapKit
import Moya


class SuppliersListViewModel: ObservableObject {
    private let organizationProvider = MoyaProvider<OrganizationProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published private var viewManager = ViewManager.shared
    
    @Published var organizations: [OrganizationModel] = []
    
    @Published var selectedProductTypes: [ProductType]? = nil
    @Published var distanceFromMe: Double? = nil
    @Published var suppliersList: [OrganizationBranchModel] = []

    @Published var selectedMarker: MapMarker? = nil
    @Published var markers: [MapMarker] = []
    
    @Published var selectedOrganization: OrganizationModel? = nil
    
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
        let filter = FilterDto(page: 0, perPage: 20)
        organizationProvider.request(.getOrganizations(filter: filter)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let response = try? response.map(PaginatedDto<OrganizationDto>.self) else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                        return
                    }
                    self?.organizations = response.items.map { item -> OrganizationModel in
                        OrganizationModel.from(item)
                    }
                } else {
                    let errorDto = try? response.map(ErrorDto.self)
                    AlertManager.shared.showAlert(.init(type: .error, description: errorDto?.message ?? "Произошла ошибка"))
                }
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
}
