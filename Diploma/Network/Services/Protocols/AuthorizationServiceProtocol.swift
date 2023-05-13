import Foundation

protocol AuthorizationServiceProtocol {
    func check(completion: @escaping (Result<AuthorizationDto, Error>) -> ())
    func login(_ authDto: AuthorizationDto, completion: @escaping (Result<AuthorizationDto, Error>) -> ())
    func register(_ authDto: AuthorizationDto, completion: @escaping (Result<AuthorizationDto, Error>) -> ())
}
