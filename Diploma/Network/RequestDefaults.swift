import Foundation

class RequestDefaults {
    public static let baseUrl = URL(string: "http://todo")!
    
    public static func baseUrl(_ apiPath: String) -> URL {
        let baseUrlString = "\(baseUrl.absoluteString)\(apiPath)"
        return URL(string: baseUrlString)!
    }
}
