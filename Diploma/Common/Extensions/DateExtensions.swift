import Foundation

extension Date {
    func startOfMonth() -> Date {
        return Calendar(identifier: .gregorian).date(from: Calendar(identifier: .gregorian).dateComponents([.year, .month], from: Calendar(identifier: .gregorian).startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
