import Foundation
import Moya

extension Result where Success == Response, Failure == MoyaError {
    func handleResponse<ResponseDto: Decodable>(_ responseType: ResponseDto.Type) -> Result<ResponseDto, Error> {
        switch self {
        case .success(let response):
            guard (200...299).contains(response.statusCode) else {
                let error = NSError(domain: "", code: response.statusCode, userInfo: nil)
                return .failure(error)
            }
            do {	                
                let dto = try response.map(ResponseDto.self)
                return .success(dto)
            } catch let error {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func ignoreResponse() -> Result<Void, Error> {
        switch self {
        case .success(let response):
            guard (200...299).contains(response.statusCode) else {
                let error = NSError(domain: "", code: response.statusCode, userInfo: nil)
                return .failure(error)
            }
            
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
