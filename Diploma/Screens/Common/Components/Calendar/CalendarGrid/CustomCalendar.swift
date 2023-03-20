import SwiftUI

struct CustomCalendar: View {
    @Binding var isRangeStartSelected: Bool
    @Binding var rangeStartDate: Date?
    @Binding var rangeEndDate: Date?
    
    var numberOfMonths = 2
    var disablePastDays = true
    
    private let calendar = Calendar(identifier: .gregorian)
    private let currentDate = Date()
    
    private var currentMonth: Int {
        calendar.component(.month, from: currentDate)
    }
    
    internal func actualDate(day: Int, month: Int) -> Date? {
        let firstDayOfMonth = calendar.date(from: DateComponents(
            calendar: calendar,
            timeZone: .current,
            year: calendar.component(.year, from: Date()),
            month: calendar.component(.month, from: Date()) + month
        ))
        
        let actualDay = day - calendar.component(.weekday, from: firstDayOfMonth ?? Date()) + 2
        let lastDay = calendar.component(.day, from: firstDayOfMonth!.endOfMonth())
        
        guard actualDay > 0 && actualDay <= lastDay else {
            return nil
        }
        
        let dateComponents = DateComponents(
            calendar: calendar,
            timeZone: .current,
            year: calendar.component(.year, from: Date()),
            month: calendar.component(.month, from: Date()) + month,
            day: actualDay
        )
        return calendar.date(from: dateComponents)
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    CustomSmallButton(icon: .customBackShort)
                    
                    Text("\(Calendar(identifier: .gregorian).component(.month, from: actualDate(day: 6, month: 0)!))")
                        .font(.customSubtitle)
                        .foregroundColor(.customOrange)
                    
                    CustomSmallButton(icon: .customBackShort).rotationEffect(Angle(degrees: 180))
                }
                
                HStack(spacing: 8) {
                    ForEach((calendar.shortWeekdaySymbols), id: \.self) { day in
                        Text("\(day)")
                            .foregroundColor(.customOrange)
                            .font(.customStandard)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(width: geo.size.width - 48)
                
                RoundedRectangle(cornerRadius: .infinity)
                    .frame(height: 1)
                    .foregroundColor(.customOrange)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top) {
                        ForEach(0...1, id: \.self) { month in
                            VStack {
                                ForEach(calendar.range(of: .weekOfMonth, in: .month, for: calendar.date(byAdding: .month, value: month, to: currentDate)!)!, id: \.self) { week in
                                    HStack{
                                        ForEach(1...7, id: \.self) { day in
                                            if let date = actualDate(day: (day + (week-1) * 7), month: month) {
                                                let cellState = getCellState(date)
                                                CustomCalendarCell(cellState: cellState, date: date) {
                                                    if isRangeStartSelected {
                                                        rangeStartDate = date
                                                    } else {
                                                        rangeEndDate = date
                                                    }
                                                }
                                                .frame(maxWidth: .infinity)
                                            } else {
                                                Circle()
                                                    .foregroundColor(.clear)
                                                    .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: geo.size.width - 48)
                        }
                    }
                }
            }
            .padding(.vertical , 16)
            .padding(.horizontal , 24)
            .background(Color.customWhite)
            .cornerRadius(8)
        }
        .scaledToFit()
    }
    
    func getCellState(_ date: Date) -> CalendarCellState {
        if let rangeStartDate,
           calendar.isDate(date, equalTo: rangeStartDate, toGranularity: .day) {
            return .selected
        }
        
        if let rangeEndDate,
           calendar.isDate(date, equalTo: rangeEndDate, toGranularity: .day) {
            return .selected
        }
        
        if let rangeStartDate,
           let rangeEndDate,
           date < rangeEndDate,
           date > rangeStartDate {
            return .inRange
        }
        
        if calendar.isDate(date, equalTo: currentDate, toGranularity: .day) {
            return .today
        }
        
        if disablePastDays,
           date < currentDate {
            return .disabled
        }

        return .enabled
    }
}

struct CustomCalendar_Previews: PreviewProvider {
    static var previews: some View {
        CustomCalendar(isRangeStartSelected: .constant(true), rangeStartDate: .constant(nil), rangeEndDate: .constant(nil))
    }
}
