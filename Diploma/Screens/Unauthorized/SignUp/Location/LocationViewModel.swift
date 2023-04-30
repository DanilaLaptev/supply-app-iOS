import Foundation
import SwiftUI
import Combine
import Moya
import MapKit


class LocationViewModel: ObservableObject {
    @Published var navigateToSignIn: Bool = false

    @Published var addressName = ""
    @Published private var placeLocation: CLLocation?
    @Published private var placeFullName: String?
    @Published private(set) var organization: OrganizationCreationModel?
    
    @Published private var locationManager = LocationManager()
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published var landmarks = [MapMarker]()
    @Published var selectedLandmark: MapMarker? = nil
    
    private var getLandmark: AnyPublisher<MapMarker, Never> {
        Publishers.CombineLatest(
            $placeLocation,
            $placeFullName
        )
        .compactMap { location, placeName in
            guard let location, let placeName else {
                Debugger.shared.printLog("couldn't get location name or coordinate")
                return nil
            }
            
            return MapMarker(name: placeName, location: location.coordinate)
        }.eraseToAnyPublisher()
    }
    
    private let organizationBranchProvider = MoyaProvider<OrganizationBranchProvider>(plugins: [NetworkLoggerPlugin()])
    
    init() {
        getLandmark
            .receive(on: RunLoop.main)
            .sink { [weak self] marker in
                self?.landmarks = [marker]
            }.store(in: &cancellableSet)
        
        $addressName
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { [weak self] addressName in
                self?.locationManager.getLocation(forPlaceCalled: addressName) { location in
                    self?.placeLocation = location
                }
            }.store(in: &cancellableSet)
        
        $placeLocation
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { [weak self] placeLocation in
                guard let placeLocation else {
                    self?.placeFullName = nil
                    return
                }
                self?.locationManager.getPlace(for: placeLocation) { placemark in
                    guard let placemark = placemark else {
                        self?.placeFullName = nil
                        return
                    }

                    var output = ""
                    if let country = placemark.country {
                        output = output + "\n\(country)"
                    }
                    if let state = placemark.administrativeArea {
                        output = output + "\n\(state)"
                    }
                    if let town = placemark.locality {
                        output = output + "\n\(town)"
                    }
                    
                    self?.placeFullName = output
                }
            }.store(in: &cancellableSet)
    }
    
    private func addOrganiztionLocation() {
        guard let selectedPlace = landmarks.first else {
            return
        }
        
        let requestBody = OrganizationBranchDto(
            addressName: selectedPlace.name,
            longitude: selectedPlace.location.longitude,
            latitude: selectedPlace.location.latitude,
            contactPersons: []
        )
        
        guard let branchId = organization?.organizationBranchId else {
            return
        }
        
        organizationBranchProvider.request(.updateOrganizationBranch(
            branchId: branchId,
            branch: requestBody
        )) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    self?.navigateToSignIn.toggle()
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
    
    func setupOrganization(_ organization: OrganizationCreationModel) {
        self.organization = organization
    }
}
