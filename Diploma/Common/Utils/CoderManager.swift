import Foundation

class CoderManager {
    static func decode<DataObject: Decodable>(_ data: Data) -> DataObject? {
        guard let decodedData = try? JSONDecoder().decode(DataObject.self, from: data) else {
            Debugger.shared.printLog("couldn't decode object: \(data)")
            return nil
        }
        return decodedData
    }
    
    static func encode<DataObject: Encodable>(_ data: DataObject) -> Data? {
        guard let encodedData = try? JSONEncoder().encode(data) else {
            Debugger.shared.printLog("couldn't encode object: \(data)")
            return nil
        }
        return encodedData
    }
}
