import SwiftUI

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

struct CustomCalendar: View {
    @State private var rangeStartDate = Date()
    @State private var rangeEndDate = Date()
    private var numberOfMonths = 3
    @State private var currentDate = Date()
    
    private let calendar = Calendar(identifier: .gregorian)
    
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
                    
                    Text("\(Calendar.current.component(.month, from: actualDate(day: 6, month: 0)!))")
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
                        ForEach(0...11, id: \.self) { month in
                            VStack {
                                ForEach(calendar.range(of: .weekOfMonth, in: .month, for: calendar.date(byAdding: .month, value: month, to: currentDate)!)!, id: \.self) { week in
                                    HStack{
                                        ForEach(1...7, id: \.self) { day in
                                            if let d = actualDate(day: (day + (week-1) * 7)-1 , month: month) {
                                                CustomCalendarCell(dayNumber: calendar.component(.day, from: d), cellState: .enabled)
                                                    .frame(maxWidth: .infinity)
                                                
                                            } else {
                                                CustomCalendarCell(dayNumber: -1, cellState: .empty)
                                                    .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                }
                                .onAppear() {
                                    print(calendar.range(of: .weekOfMonth, in: .month, for: calendar.date(byAdding: .month, value: month, to: currentDate)!)!, calendar.monthSymbols[month])
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
}

struct CustomCalendar_Previews: PreviewProvider {
    static var previews: some View {
        CustomCalendar()
    }
}
