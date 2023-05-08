import Foundation

extension String {
    func toDate(_ mask: String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = mask
        
        return dateFormatter.date(from: self)
    }
}
