import Foundation

protocol MoyaCacheable {
  typealias CachePolicy = URLRequest.CachePolicy
  var cachePolicy: CachePolicy { get }
}
