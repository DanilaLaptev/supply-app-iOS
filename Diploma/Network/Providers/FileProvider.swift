import Foundation
import Moya


enum FileProvider {
    case upload(image: Data)
    case getFile(imageName: String)
}

extension FileProvider: TargetType {
    var baseURL: URL { RequestDefaults.baseUrl("/image") }
    
    var path: String {
        switch self {
        case .upload:
            return "/"
        case .getFile(let imageName):
            return "/\(imageName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .upload:
            return .post
        case .getFile:
            return .get
        }
    }
    
    // TODO: data for requests
    var task: Task {
        switch self {
        case .upload(let imageData):
            return .uploadMultipart([.init(provider: .data(imageData), name: "file", fileName: "image_\(Date()).jpeg", mimeType: "jpeg")])
        case .getFile:
            return .requestPlain
        }
    }
    
    // TODO: real samples
    var sampleData: Data {
        switch self {
        case .upload:
            return .init()
        case .getFile:
            return .init()
        }
    }
    
    var headers: [String: String]? {
        return RequestHeader.withAccessToken
    }
}

extension FileProvider: MoyaCacheable {
    var cachePolicy: CachePolicy {
        switch self {
        case .getFile:
            return .returnCacheDataElseLoad
        default:
            return .reloadIgnoringLocalAndRemoteCacheData
        }
    }
}
