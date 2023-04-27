import Foundation

class RequestDefaults {
    public static let baseUrl = URL(string: "http://192.168.2.179:9090")!
    
    public static func baseUrl(_ apiPath: String) -> URL {
        let baseUrlString = "\(baseUrl.absoluteString)\(apiPath)"
        return URL(string: baseUrlString)!
    }
}
