import SwiftUI

enum CalendarCellState {
    case inRange
    case enabled
    case disabled
    case today
}

struct CustomCalendarCell: View {
    @State var selected = false
    @State var cellState: CalendarCellState = .disabled
    var date: Date
    var onTap: (() -> ())?
    
    private var dateOfMonth: Int {
        return Calendar.current.component(.day, from: date)
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
            
            Text("\(dateOfMonth)")
                .foregroundColor(selected ? .customWhite : cellForeground)
                .font(.customStandard)
        }
        .onTapGesture {
            if case .disabled = cellState { return }
            selected.toggle()
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
    }
}
