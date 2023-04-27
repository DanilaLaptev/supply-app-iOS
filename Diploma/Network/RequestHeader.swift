import Foundation

class RequestHeader {
    static var standard: [String: String] {
        var header: [String: String] = [
            "Content-Type" : "application/json"
        ]

        return header
    }
}
