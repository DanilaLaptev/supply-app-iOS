import Foundation
import SwiftUI
import Combine
import Moya


class OrganizationImageViewModel: ObservableObject {
    @Published var navigateToLocationView = false
    @Published var selectedImage: UIImage?

    private var fileProvider = MoyaProvider<FileProvider>(plugins: [NetworkLoggerPlugin()])
    private var organizationProvider = MoyaProvider<OrganizationProvider>(plugins: [NetworkLoggerPlugin()])
    private var cancellableSet = Set<AnyCancellable>()
    
    private var uploadedImageName: String?
    
    init() {
        
    }
    
    // TODO: compress func
    func compressImageData(_ image: UIImage?, maxSizeMB: Int) -> Data? {
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
        
        fileProvider.request(.upload(image: imageData)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    guard let self,
                          let response = try? response.map(ImageDto.self) else {
                        AlertManager.shared.showAlert(.init(type: .error, description: "Произошла ошибка"))
                        return
                    }
                    self.uploadedImageName = response.image
                    self.updateOrganizationImage()
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
    
    private func updateOrganizationImage() {
        guard let uploadedImageName else {
            return
        }
        
        let requestBody = OrganizationDto(
            branches: [],
            image: "\(RequestDefaults.baseUrl("/image"))/\(uploadedImageName)"
        )
        
        organizationProvider.request(.updateOrganization(organization: requestBody)) { [weak self] result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    self?.navigateToLocationView.toggle()
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
