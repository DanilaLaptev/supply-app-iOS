import Foundation
import SwiftUI
import Keychain

class KeychainConstants {
    static let user = "user"
}

final class KeychainManager {
    static let shared = KeychainManager()
    private init() { }
    
    static func saveUser(_ user: KeychainUserModel) -> Bool {
        guard let jsonUser = try? JSONEncoder().encode(user),
              let userJsonString = String(data: jsonUser, encoding: .utf8) else {
            Debugger.shared.printLog("couldn't convert user to json")
            return false
        }
        
        return Keychain.save(userJsonString, forKey: KeychainConstants.user)
    }
    
    static func getUser() -> KeychainUserModel? {
        guard let jsonUser = Keychain.load(KeychainConstants.user)?.data(using: .utf8),
              let userModel = try? JSONDecoder().decode(KeychainUserModel.self, from: jsonUser) else {
            Debugger.shared.printLog("couldn't decode user from json")
            return nil
        }
        
        return userModel
    }
}
