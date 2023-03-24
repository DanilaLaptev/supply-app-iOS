import Foundation

enum FileManagerError: Error {
    case dataArrayIsEmpty
    case creatingFilePathError
    case writtingToFileError
    case parsingError
}

class FileManager {
    public static let shared = FileManager()
    
    func exportCSV<DataObject: Encodable>(
        fileName: String = "\(Date().description).csv",
        dataArray: [DataObject]
    ) -> Result<URL, FileManagerError> {
        guard !dataArray.isEmpty else {
            Debugger.shared.printLog("data array is empty")
            return .failure(.dataArrayIsEmpty)
        }
        
        guard let filePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName) else {
            Debugger.shared.printLog("couldn't get file path")
            return .failure(.creatingFilePathError)
        }
        
        let jsonDataArray = dataArray.compactMap { $0.dictionary }
    
        let keys = jsonDataArray.first!.map { key, _ in key }
        let header = "\(keys.joined(separator: ","))\n"
        
        let allValues = jsonDataArray.map { objectDictionary in
            let objectValues = keys.map { key in
                return "\(objectDictionary[key] ?? "none")"
            }
            return objectValues.joined(separator: ",")
        }
        
        let fileContent = header + allValues.joined(separator: "\n")
        
        do {
            try fileContent.write(to: filePath, atomically: true, encoding: .utf8)
        } catch {
            Debugger.shared.printLog("couldn't write to file")
            return .failure(.writtingToFileError)
        }
        
        return .success(filePath)
    }
}
