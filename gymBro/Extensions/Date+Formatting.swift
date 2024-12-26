import Foundation

extension Date {
    public func toWeekdayAbbreviation(with date: Date) -> String {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date).capitalized
    }
}
