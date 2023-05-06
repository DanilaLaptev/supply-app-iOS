import Foundation

class RequestDefaults {
    private static var baseUrl = "http://192.168.3.98:9090"
    
    public static func baseUrl(_ apiPath: String = "/") -> URL {
        let baseUrlString = "\(baseUrl)\(apiPath)"
        return URL(string: baseUrlString)!
    }
    
    public static func changeBaseUrl(_ newIp: String) {
        guard let newBaseUrl = URL(string: "http://\(newIp):9090") else {
            Debugger.shared.printLog("new ip couldn't be converted to url")
            return
        }
        baseUrl = newBaseUrl.absoluteString
    }
}
