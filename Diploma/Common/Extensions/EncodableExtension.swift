import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            Debugger.shared.printLog("couldn't get data")
            return nil
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
            Debugger.shared.printLog("couldn't convert data to json object")
            return nil
        }
        
        return jsonObject
    }
}
