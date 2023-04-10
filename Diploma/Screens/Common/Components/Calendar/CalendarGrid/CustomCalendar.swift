import SwiftUI

struct CustomCalendar: View {
    @Binding var isRangeStartSelected: Bool
    @Binding var rangeStartDate: Date?
    @Binding var rangeEndDate: Date?
    
    @State var monthOffset = 0
    
    var numberOfMonths = 2
    var disablePastDays = true
    
    private let calendar = Calendar(identifier: .gregorian)
    @State private var currentDate = Date()
    private let today = Date()

    private var currentMonth: String {
        return DateFormatManager.shared.getFormattedString(currentDate, dateFormat: "MMMM yyyy")
    }
    
    private var isRangeSelected: Bool {
        rangeStartDate != nil && rangeEndDate != nil
    }
    
    private func actualDate(dayOfWeek: Int, weekOfMonth: Int) -> Date? {
        let dateComponents = DateComponents(
            calendar: calendar,
            year: calendar.component(.year, from: currentDate),
            month: calendar.component(.month, from: currentDate),
            weekday: dayOfWeek,
            weekOfMonth: weekOfMonth
        )
        
        if dateComponents.isValidDate(in: calendar) {
            print(calendar.date(from: dateComponents))
            return calendar.date(from: dateComponents)
        }
        
        return nil
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    CustomSmallButton(icon: .customBackShort) {
                        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
                    }
                    
                    Text(currentMonth)
                        .font(.customSubtitle)
                        .foregroundColor(.customOrange)
                    
                    CustomSmallButton(icon: .customBackShort) {
                        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                    }
                    .rotationEffect(Angle(degrees: 180))
                }
                
                HStack(spacing: 0) {
                    ForEach(Weekdays.allCases, id: \.self) { day in
                        Text(day.rawValue)
                            .lineLimit(1)
                            .foregroundColor(.customOrange)
                            .font(.customStandard)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                RoundedRectangle(cornerRadius: .infinity)
                    .frame(height: 1)
                    .foregroundColor(.customOrange)
                
                    HStack(alignment: .top) {
                            VStack(spacing: 0) {
                                ForEach(getNumberOfWeeksInMonth(currentDate), id: \.self) { week in
                                    Spacer()
                                    HStack {
                                        ForEach(1...7, id: \.self) { day in
                                            Spacer()
                                            if let date = actualDate(dayOfWeek: day, weekOfMonth: week) {
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
                            .clipped()
                            .frame(width: geo.size.width)
                    }
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
        
        if calendar.isDate(date, equalTo: today, toGranularity: .day) {
            return .today
        }
        
        if disablePastDays,
           date < today {
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
