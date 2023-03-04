import SwiftUI

struct CustomCalendar: View {
    @State private var rangeStartDate = Date()
    @State private var rangeEndDate = Date()

    @State private var currentDate = Date()
    
    private let calendar = Calendar(identifier: .gregorian)

    private var dateComponents: DateComponents {
        calendar.dateComponents([.day, .weekOfMonth, .month, .year], from: Date())
    }
    
    private var today: Int {
        calendar.firstWeekday
    }
    
    private var month: String {
        return "\(calendar.monthSymbols[dateComponents.month!])"
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(month)")
            HStack(spacing: 16) {
                CustomSmallButton(icon: .customBackShort)
                
                Text("\(today)")
                    .font(.customSubtitle)
                    .foregroundColor(.customOrange)
                
                CustomSmallButton(icon: .customBackShort).rotationEffect(Angle(degrees: 180))
                
            }
            
            HStack(spacing: 16) {
                ForEach((calendar.shortWeekdaySymbols), id: \.self) { day in
                    VStack(spacing: 16) {
                        Text("\(day)")
                            .foregroundColor(.customOrange)
                            .font(.customStandard)
                        
                        ForEach((1...5), id: \.self) {
                            CustomCalendarCell(dayNumber: $0, cellState: .enabled)
                        }
                    }
                }
            }
        }
        .padding(.vertical , 8)
        .padding(.horizontal , 24)
        .cornerRadius(8)
    }
}

struct CustomCalendar_Previews: PreviewProvider {
    static var previews: some View {
        CustomCalendar()
    }
}

enum CalendarCellState {
    case inRange
    case enabled
    case disabled
    case today
    case empty
}

struct CustomCalendarCell: View {
    @State private var selected = false
    @State private var cellState: CalendarCellState
    private let dayNumber: Int
    
    init(dayNumber: Int, cellState: CalendarCellState) {
        self.dayNumber = dayNumber
        self.cellState = cellState
    }
    
    var cellForeground: Color {
        switch cellState {
        case .inRange:
            return .customOrange
        case .enabled:
            return .customBlack
        case .disabled:
            return .customDarkGray
        case .empty:
            return .customWhite
        case .today:
            return .customWhite
        }
    }
    
    var cellBackground: Color {
        switch cellState {
        case .inRange:
            return .customLightOrange
        case .enabled:
            return .customWhite
        case .disabled:
            return .customWhite
        case .empty:
            return .customWhite
        case .today:
            return .customOrange
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .foregroundColor(selected ? .customOrange : cellBackground)
                
            Text("\(dayNumber)")
                .foregroundColor(selected ? .customWhite : cellForeground)
                .font(.customStandard)
        }
        .onTapGesture {
            if case .disabled = cellState { return }
            if case .empty = cellState { return }
            selected.toggle()
        }
    }
}
