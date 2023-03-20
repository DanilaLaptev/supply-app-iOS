import SwiftUI

enum CalendarCellState {
    case inRange
    case startRange
    case endRange
    case enabled
    case disabled
    case today
}

struct CustomCalendarCell: View {
    var rangeSelected: Bool = false
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
        case .startRange, .endRange:
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
        case .startRange, .endRange:
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
    
    private var zIndex: Double {
        switch cellState {
        case .inRange:
            return 1
        default:
            return 2
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if case .inRange = cellState {
                Rectangle()
                    .foregroundColor(cellBackground)
                    .frame(height: 32)
                    .padding(.horizontal, -16)
            }
            
            if rangeSelected,
               case .startRange = cellState {
                Rectangle()
                    .foregroundColor(.customLightOrange)
                    .frame(height: 32)
                    .padding(.leading, 16)
                    .padding(.trailing, -4)
            }
            
            if rangeSelected,
               case .endRange = cellState {
                Rectangle()
                    .foregroundColor(.customLightOrange)
                    .frame(height: 32)
                    .padding(.trailing, 16)
                    .padding(.leading, -4)
            }
            
            Circle()
                .strokeBorder(Color.customOrange, lineWidth: isToday ? 1 : 0)
                .background(Circle().foregroundColor(cellBackground))
                .frame(height: 32)
            
            Text("\(dateOfMonth)")
                .foregroundColor(cellForeground)
                .font(.customStandard)
        }
        .zIndex(zIndex)
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
        CustomCalendarCell(cellState: .startRange, date: Date())
        CustomCalendarCell(cellState: .endRange, date: Date())
    }
}
