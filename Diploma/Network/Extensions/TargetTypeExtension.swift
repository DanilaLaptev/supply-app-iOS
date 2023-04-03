import Foundation
import Moya

extension TargetType {
    func convertToData<EncodableObject: Encodable>(_ dataObject: EncodableObject) -> Data? {
        guard let data = try? JSONEncoder().encode(dataObject) else {
            Debugger.shared.printLog("Object of type \(type(of: dataObject)) couldn't be converted to Data")
            return nil
        }
        
        return data
    }
}
