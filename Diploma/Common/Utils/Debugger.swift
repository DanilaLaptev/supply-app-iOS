import Foundation

class Debugger {
    public static let shared = Debugger()
    
    public func printLog(tag: String = "DEBUG", _ message: String) {
        print("\(tag): \(message)")
    }
}
