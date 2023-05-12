import Foundation

class CustomFileManager {
    public static let shared = CustomFileManager()
    
    func convertToCSV<Item>(
        _ data: [Item],
        fileName: String = "\(Date().description)",
        rowBuilder: (Item) -> [(name: String, value: Any)]
    ) -> URL? {
        guard let firstItem = data.first else {
            Debugger.shared.printLog("data array is empty")
            return nil
        }
        
        let header = rowBuilder(firstItem).map({ name, _ in name }).joined(separator: ",")
        
        let rows = data.map { rowBuilder($0).map { String(describing: $0.value) }.joined(separator: ",") }
        let csv = ([header] + rows).joined(separator: "\n")
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentDirectory.appendingPathComponent(fileName).appendingPathExtension("csv")
        
        do {
            try csv.write(to: fileURL, atomically: true, encoding: .utf8)
            Debugger.shared.printLog("CSV file saved to: \(fileURL)")
        } catch {
            Debugger.shared.printLog("couldn't write to file")
        }
        
        return fileURL
    }
}
