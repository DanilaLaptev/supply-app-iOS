import Foundation

class RequestHeader {
    static var withAccessToken: [String: String] {
        let accessToken: String = KeychainManager.shared.get(.accessToken) ?? "none"
        
        let header: [String: String] = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(accessToken)"
        ]

        return header
    }
    
    static var standard: [String: String] {
        let header: [String: String] = [
            "Content-Type" : "application/json"
        ]

        return header
    }
}
