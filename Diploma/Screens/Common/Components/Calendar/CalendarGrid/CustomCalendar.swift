import SwiftUI

struct CustomCalendar: View {
    @Binding var isRangeStartSelected: Bool
    @Binding var rangeStartDate: Date?
    @Binding var rangeEndDate: Date?
    
    @State var monthOffset = 0
    
    var numberOfMonths = 2
    var disablePastDays = true
    
    private let calendar = Calendar(identifier: .gregorian)
    private let currentDate = Date()
    
    private var currentMonth: String {
        return DateFormatManager.shared.getFormattedString(currentDate, dateFormat: "MMMM yyyy")
    }
    
    private var isRangeSelected: Bool {
        rangeStartDate != nil && rangeEndDate != nil
    }
    
    internal func actualDate(day: Int, month: Int) -> Date? {
        let firstDayOfMonth = calendar.date(from: DateComponents(
            calendar: calendar,
            timeZone: .current,
            year: calendar.component(.year, from: Date()),
            month: calendar.component(.month, from: Date()) + month,
            hour: 0,
            minute: 0,
            second: 0,
            nanosecond: 0
        ))
        
        let actualDay = day - calendar.component(.weekday, from: firstDayOfMonth ?? Date()) + 1
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
                    CustomSmallButton(icon: .customBackShort) {
                        if monthOffset > 0 {
                            monthOffset -= 1
                        }
                    }
                    
                    Text(currentMonth)
                        .font(.customSubtitle)
                        .foregroundColor(.customOrange)
                    
                    CustomSmallButton(icon: .customBackShort) {
                        monthOffset += 1
                    }
                    .rotationEffect(Angle(degrees: 180))
                }
                
                HStack(spacing: 0) {
                    ForEach((calendar.shortWeekdaySymbols), id: \.self) { day in
                        Text("\(day)")
                            .lineLimit(1)
                            .foregroundColor(.customOrange)
                            .font(.customStandard)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                RoundedRectangle(cornerRadius: .infinity)
                    .frame(height: 1)
                    .foregroundColor(.customOrange)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top) {
                        ForEach(0...16, id: \.self) { month in
                            VStack(spacing: 0) {
                                ForEach(getNumberOfWeeksInMonth(calendar.date(byAdding: .month, value: month, to: currentDate)!), id: \.self) { week in
                                    Spacer()
                                    HStack {
                                        ForEach(1...7, id: \.self) { day in
                                            Spacer()
                                            if let date = actualDate(day: (day + (week-1) * 7), month: month) {
                                                let cellState = getCellState(date)
                                                CustomCalendarCell(rangeSelected: isRangeSelected, cellState: cellState, date: date) {
                                                    selectCell(date)
                                                }
                                            } else {
                                                Circle()
                                                    .foregroundColor(.clear)
                                                    .frame(height: 32)
                                            }
                                            Spacer()
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            .clipped()
                            .frame(width: geo.size.width)
                        }
                    }
                    .offset(x: -(geo.size.width * CGFloat(monthOffset)) - CGFloat(monthOffset * 8))
                }
            }
            .padding(.vertical , 16)
            .background(Color.customWhite)
            .cornerRadius(8)
        }
        .scaledToFit()
    }
    
    func getCellState(_ date: Date) -> CalendarCellState {
        if let rangeStartDate,
           calendar.isDate(date, equalTo: rangeStartDate, toGranularity: .day) {
            return .startRange
        }
        
        if let rangeEndDate,
           calendar.isDate(date, equalTo: rangeEndDate, toGranularity: .day) {
            return .endRange
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
    
    func getNumberOfWeeksInMonth(_ date: Date) -> Range<Int> {
        let weeks = calendar.range(of: .weekOfMonth, in: .month, for: date)!
        return weeks
    }
    
    func selectCell(_ date: Date) {
        if isRangeStartSelected, let endRange = rangeEndDate {
            rangeStartDate = date
            if endRange < date {
                rangeEndDate = nil
                isRangeStartSelected = false
            }
            return
        }
        
        if !isRangeStartSelected, let startRange = rangeStartDate {
            rangeEndDate = date
            if startRange > date {
                rangeEndDate = nil
                rangeStartDate = date
                isRangeStartSelected = false
            }
            
            return
        }
        
        if isRangeStartSelected {
            rangeStartDate = date
        } else {
            rangeEndDate = date
        }
        
        if rangeStartDate == nil || rangeEndDate == nil {
            isRangeStartSelected.toggle()
        }
    }
}

struct CustomCalendar_Previews: PreviewProvider {
    static var previews: some View {
        CustomCalendar(isRangeStartSelected: .constant(true), rangeStartDate: .constant(nil), rangeEndDate: .constant(nil))
    }
}
