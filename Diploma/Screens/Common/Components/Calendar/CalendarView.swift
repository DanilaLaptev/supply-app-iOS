import SwiftUI

struct CalendarView: View {
    @State var isStartRangeSelected: Bool = true
    @State var startDate: Date? = nil
    @State var endDate: Date? = nil

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
    static var previews: some View {
        CalendarView()
    }
}
