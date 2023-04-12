import Foundation

class DateFormatManager {
    public static let shared = DateFormatManager()
    
    func getFormattedString(_ date: Date, dateFormat: String, timeZoneName: String = "UTC") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = .init(identifier: "ru")
        dateFormatter.timeZone = .init(identifier: timeZoneName)
        
        return dateFormatter.string(from: date)
    }
}
