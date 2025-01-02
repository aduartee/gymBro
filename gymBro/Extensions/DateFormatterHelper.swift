import Foundation

class DateFormatterHelper {
    static let shared = DateFormatterHelper()
    private let weekDayFormatter: DateFormatter
    private let dayAndMonthFormatter: DateFormatter
    private let calendar: Calendar
    private init() {
        weekDayFormatter = DateFormatter()
        weekDayFormatter.dateFormat = "EEE"
        dayAndMonthFormatter = DateFormatter()
        dayAndMonthFormatter.dateFormat = "dd MMM"
        calendar = Calendar.current
    }
    
    func removeTime(from date: Date) -> Date {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date) ?? date
    }
    
    func toWeekdayAbbreviation(with date: Date) -> String {
        return weekDayFormatter.string(from: date).capitalized
    }
    
    func formatDateToDayAndMonth(with date: Date) -> String {
        return dayAndMonthFormatter.string(from: date).uppercased()
    }
}
