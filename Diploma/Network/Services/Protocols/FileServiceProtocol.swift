import Foundation

protocol FileServiceProtocol {
    func upload(image: Data, completion: @escaping (Result<ImageDto, Error>) -> ())
    func getFile(imageName: String, completion: @escaping (Result<Void, Error>) -> ())
}
