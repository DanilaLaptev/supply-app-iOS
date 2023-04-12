import SwiftUI

struct CalendarView: View {
    @State var isStartRangeSelected: Bool = true
    @Binding var startDate: Date?
    @Binding var endDate: Date?

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            DateRangeSegmentsView(isRangeStartSelected: $isStartRangeSelected, startRangeDate: $startDate, endRangeDate: $endDate)
                .padding(.horizontal, 24)
            CustomCalendar(isRangeStartSelected: $isStartRangeSelected, rangeStartDate: $startDate, rangeEndDate: $endDate)
        }
        .padding(16)
        .background(Color.customWhite)
        .cornerRadius(8)
    }
}

struct CalendarView_Previews: PreviewProvider {
    @State static var start: Date? = nil
    @State static var end: Date? = nil
    
    static var previews: some View {
        CalendarView(startDate: $start, endDate: $end)
    }
}
