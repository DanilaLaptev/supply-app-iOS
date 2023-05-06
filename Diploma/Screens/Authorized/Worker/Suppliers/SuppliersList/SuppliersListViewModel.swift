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
    
    @Published var organizationNameFilter: String = ""
    @Published var organizationProductTypes: [ProductType] = []
    
    
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
        Publishers.CombineLatest(
            $organizationNameFilter.removeDuplicates(),
            $organizationProductTypes.removeDuplicates()
        )
        .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
        .map { _, _ in () }.eraseToAnyPublisher()
    }
    
    init() {
        markersPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] markers in
                self?.markers = markers
            }.store(in: &cancellableSet)
        
        updateFiltersPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] markers in
                self?.page = 0
                self?.organizations = []
                self?.fetchOrganizations()
            }.store(in: &cancellableSet)
    }
    
    func setSelectedOrganization(_ organization: OrganizationModel) {
        selectedOrganization = organization
    }
    
    func fetchOrganizations() {
        guard page != -1 else {
            return
        }
        
        let productTypes = organizationProductTypes.isEmpty ? nil : organizationProductTypes
        
        let filter = FilterDto(
            role: .supplier,
            title: organizationNameFilter,
            productType: productTypes,
            page: 0,
            perPage: 20
        )
        
        organizationProvider.request(.getOrganizations(filter: filter)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let self,
                          let response = try? response.map(PaginatedDto<OrganizationDto>.self),
                          let total = response.total else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                        return
                    }
                    let receivedOrganizations = response.items.map { item -> OrganizationModel in
                        OrganizationModel.from(item)
                    }
                    
                    self.organizations += receivedOrganizations
                    self.page = total > self.organizations.count ? self.page + 1 : -1

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
