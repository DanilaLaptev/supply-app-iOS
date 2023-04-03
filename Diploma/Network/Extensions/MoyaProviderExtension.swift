import Foundation
import Moya

extension MoyaProvider {
    public static func getProvider<Provider: TargetType>(
        stubsBehavior: @escaping (Provider) -> StubBehavior = MoyaProvider.neverStub,
        plugins: [PluginType] = [NetworkLoggerPlugin()]
    ) -> MoyaProvider<Provider> {
        return MoyaProvider<Provider>(stubClosure: stubsBehavior, plugins: plugins)
    }
}
