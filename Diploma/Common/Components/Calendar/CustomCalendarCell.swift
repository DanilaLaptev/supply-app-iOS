import SwiftUI

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
                .frame(height: 32)
                .aspectRatio(1 / 1, contentMode: .fit)
            
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

struct CustomCalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        CustomCalendarCell(dayNumber: 1, cellState: .empty)
        CustomCalendarCell(dayNumber: 1, cellState: .disabled)
        CustomCalendarCell(dayNumber: 1, cellState: .enabled)
        CustomCalendarCell(dayNumber: 1, cellState: .inRange)
        CustomCalendarCell(dayNumber: 1, cellState: .today)
    }
}
