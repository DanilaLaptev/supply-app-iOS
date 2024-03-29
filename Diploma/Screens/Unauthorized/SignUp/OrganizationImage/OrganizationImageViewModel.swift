import Foundation
import SwiftUI
import Combine


class OrganizationImageViewModel: ObservableObject {
    private let fileService: FileServiceProtocol
    private let organizationService: OrganizationServiceProtocol
    private var cancellableSet = Set<AnyCancellable>()

    @Published var navigateToLocationView = false
    @Published var selectedImage: UIImage?
        
    private var uploadedImageName: String?
    
    init(
        fileService: FileServiceProtocol = FileService(),
        organizationService: OrganizationServiceProtocol = OrganizationService()
    ) {
        self.fileService = fileService
        self.organizationService = organizationService
    }
    
    private func compressImageData(_ image: UIImage?, maxSizeMB: Int) -> Data? {
        guard let image else { return nil }
        
        let maxSizeBytes = maxSizeMB * 1024 * 1024
        var compressionQuality: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compressionQuality)
        
        while imageData?.count ?? 0 > maxSizeBytes && compressionQuality > 0.01 {
            compressionQuality -= 0.1
            imageData = image.jpegData(compressionQuality: compressionQuality)
        }
        
        return imageData
    }
    
    func uploadImage() {
        guard let imageData = compressImageData(selectedImage, maxSizeMB: 1) else {
            AlertManager.shared.showAlert(.init(type: .error, description: "Выберите фотографию для организации"))
            return
        }
        
        fileService.upload(image: imageData) { [weak self] result in
            switch result {
            case .success(let response):
                self?.uploadedImageName = response.image
                self?.updateOrganizationImage()
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
    
    private func updateOrganizationImage() {
        guard let uploadedImageName else {
            return
        }
        
        let requestBody = OrganizationDto(
            branches: [],
            image: "\(RequestDefaults.baseUrl("/image"))/\(uploadedImageName)"
        )
        
        organizationService.updateOrganization(organization: requestBody) { [weak self] result in
            switch result {
            case .success:
                self?.navigateToLocationView.toggle()
            case .failure(let error):
                Debugger.shared.printLog("Ошибка сети: \(error.localizedDescription)")
                AlertManager.shared.showAlert(.init(type: .error, description: "Сервер недоступен или был превышен лимит времени на запрос"))
            }
        }
    }
}
