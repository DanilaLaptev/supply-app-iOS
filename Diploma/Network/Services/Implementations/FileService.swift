import Foundation
import Moya

struct FileService: FileServiceProtocol {
    private let provider: MoyaProvider<FileProvider>
    
    init(provider: MoyaProvider<FileProvider> = MoyaProvider<FileProvider>(plugins: [NetworkLoggerPlugin()])) {
        self.provider = provider
    }
    
    func upload(image: Data, completion: @escaping (Result<ImageDto, Error>) -> ()) {
        provider.request(.upload(image: image)) { result in
            completion(result.handleResponse(ImageDto.self))
        }
    }
    
    func getFile(imageName: String, completion: @escaping (Result<EmptyDto, Error>) -> ()) {
        provider.request(.getFile(imageName: imageName)) { result in
            completion(result.handleResponse(EmptyDto.self))
        }
    }
}
