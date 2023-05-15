import Foundation
import SwiftUI
import Combine
import MapKit


class LocationViewModel: ObservableObject {
    private let organizationBranchService: OrganizationBranchServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()

    @Published var navigateToSignIn: Bool = false
    
    @Published var addressName = ""
    @Published private var placeLocation: CLLocation?
    @Published private var placeFullName: String?
    @Published private(set) var organization: OrganizationCreationModel?
    
    @Published private var locationManager = LocationManager()
    
    @Published var landmarks = [MapMarker]()
    @Published var selectedLandmark: MapMarker? = nil
    
    private var getLandmark: AnyPublisher<MapMarker, Never> {
        Publishers.Zip(
            $placeLocation,
            $placeFullName
        )
        .dropFirst()
        .compactMap { location, placeName in
            guard let location, let placeName else {
                Debugger.shared.printLog("couldn't get location name or coordinate")
                return nil
            }
            
            return MapMarker(name: placeName, location: location.coordinate)
        }.eraseToAnyPublisher()
    }
        
    init(organizationBranchService: OrganizationBranchServiceProtocol = OrganizationBranchService()) {
        self.organizationBranchService = organizationBranchService
        
        setupBindings()
    }
    
    private func setupBindings() {
        getLandmark
            .receive(on: RunLoop.main)
            .sink { [weak self] marker in
                self?.landmarks = [marker]
            }.store(in: &cancellableSet)
        
        $addressName
            .dropFirst()
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] addressName in
                self?.locationManager.getLocation(forPlaceCalled: addressName) { location in
                    guard let location else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Ошибка при обработке адреса"))
                        self?.placeLocation = nil
                        return
                    }
                    
                    self?.placeLocation = location
                }
            }.store(in: &cancellableSet)
        
        $placeLocation
            .dropFirst()
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] placeLocation in
                guard let placeLocation else {
                    self?.placeFullName = nil
                    return
                }
                self?.locationManager.getPlace(for: placeLocation) { placemark in
                    guard let placemark = placemark else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Ошибка при обработке адреса"))
                        self?.placeFullName = nil
                        return
                    }
                    
                    guard let fullName = placemark.name else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Ошибка при обработке адреса"))
                        self?.placeFullName = nil
                        return
                    }
                    
                    self?.placeFullName = fullName
                }
            }.store(in: &cancellableSet)
    }
    
    func addOrganiztionLocation() {
        guard let selectedPlace = landmarks.first else {
            return
        }
        
        let requestBody = OrganizationBranchDto(
            addressName: selectedPlace.name,
            longitude: selectedPlace.location.longitude,
            latitude: selectedPlace.location.latitude,
            contactPeople: []
        )
        
        guard let branchId = organization?.organizationBranchId else {
            return
        }
        
        organizationBranchService.updateOrganizationBranch(
            branchId: branchId,
            branch: requestBody
        ) { [weak self] result in
            switch result {
            case .success:
                self?.navigateToSignIn.toggle()
                AlertManager.shared.showAlert(.init(type: .success, description: "Организация создана"))
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
