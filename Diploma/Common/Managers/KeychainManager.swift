import Foundation
import SwiftUI
import Keychain

enum KeychainConstants: String {
    case user = "user"
    case accessToken = "accessToken"
    case organizationId = "organizationId"
    case branchId = "branchId"
}

final class KeychainManager {
    static let shared = KeychainManager()
    private init() { }
    
    func save<DataObject: Encodable>(_ data: DataObject, key: KeychainConstants) -> Bool {
        guard let jsonData = try? JSONEncoder().encode(data),
              let jsonDataString = String(data: jsonData, encoding: .utf8) else {
            Debugger.shared.printLog("couldn't convert object of type \(DataObject.self) to json")
            return false
        }
        
        return Keychain.save(jsonDataString, forKey: key.rawValue)
    }
    
    func get<DataObject: Decodable>(_ key: KeychainConstants) -> DataObject? {
        guard let jsonData = Keychain.load(key.rawValue)?.data(using: .utf8),
              let dataModel = try? JSONDecoder().decode(DataObject.self, from: jsonData) else {
            Debugger.shared.printLog("couldn't decode object of type \(DataObject.self) from json")
            return nil
        }
        
        return dataModel
    }
}
