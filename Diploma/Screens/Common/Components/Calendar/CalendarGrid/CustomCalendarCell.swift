import SwiftUI

enum CalendarCellState {
    case inRange
    case selected
    case enabled
    case disabled
    case today
}

struct CustomCalendarCell: View {
    var cellState: CalendarCellState
    var date: Date
    var onTap: (() -> ())?
    
    private var dateOfMonth: Int {
        return Calendar(identifier: .gregorian).component(.day, from: date)
    }
    
    private var cellForeground: Color {
        switch cellState {
        case .inRange:
            return .customOrange
        case .enabled:
            return .customBlack
        case .disabled:
            return .customDarkGray
        case .today:
            return .customOrange
        case .selected:
            return .customWhite
        }
    }
    
    private var cellBackground: Color {
        switch cellState {
        case .inRange:
            return .customLightOrange
        case .enabled:
            return .customWhite
        case .disabled:
            return .customWhite
        case .selected:
            return .customOrange
        case .today:
            return .customWhite
        }
    }
    
    private var isToday: Bool {
        if case .today = cellState {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .strokeBorder(Color.customOrange, lineWidth: isToday ? 1 : 0)
                .background(Circle().foregroundColor(cellBackground))
                .frame(height: 32)
            
            Text("\(dateOfMonth)")
                .foregroundColor(cellForeground)
                .font(.customStandard)
        }
        .onTapGesture {
            if case .disabled = cellState { return }
            onTap?()
        }
    }
}

struct CustomCalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        CustomCalendarCell(cellState: .disabled, date: Date())
        CustomCalendarCell(cellState: .enabled, date: Date())
        CustomCalendarCell(cellState: .inRange, date: Date())
        CustomCalendarCell(cellState: .today, date: Date())
        CustomCalendarCell(cellState: .selected, date: Date())
    }
}
