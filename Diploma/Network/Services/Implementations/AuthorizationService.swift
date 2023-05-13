import Foundation
import Moya

struct AuthorizationService: AuthorizationServiceProtocol {
    private let provider: MoyaProvider<AuthorizationProvider>
    
    init(provider: MoyaProvider<AuthorizationProvider> = MoyaProvider<AuthorizationProvider>(plugins: [NetworkLoggerPlugin()])) {
        self.provider = provider
    }
    
    func check(completion: @escaping (Result<AuthorizationDto, Error>) -> ()) {
        provider.request(.check) { result in
            completion(result.handleResponse(AuthorizationDto.self))
        }
    }
    
    func login(_ authDto: AuthorizationDto, completion: @escaping (Result<AuthorizationDto, Error>) -> ()) {
        provider.request(.login(authDto)) { result in
            completion(result.handleResponse(AuthorizationDto.self))
        }
    }
    
    func register(_ authDto: AuthorizationDto, completion: @escaping (Result<AuthorizationDto, Error>) -> ()) {
        provider.request(.register(authDto)) { result in
            completion(result.handleResponse(AuthorizationDto.self))
        }
    }
}
