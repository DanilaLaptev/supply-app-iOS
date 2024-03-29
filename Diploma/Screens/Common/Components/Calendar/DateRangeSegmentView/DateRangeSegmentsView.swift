import SwiftUI

struct DateRangeSegmentsView: View {
    @Binding var isRangeStartSelected: Bool
    @Binding var startRangeDate: Date?
    @Binding var endRangeDate: Date?

    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            DateRangeSegment(selectedDate: $startRangeDate, isSelected: $isRangeStartSelected, title: "Start") {
                isRangeStartSelected = true
            } onDismiss: {
                clearRange()
            }
            
            DateRangeSegment(selectedDate: $endRangeDate, isSelected: .constant(!isRangeStartSelected), title: "End") {
                isRangeStartSelected = false
            } onDismiss: {
                clearRange()
            }
        }
        .padding(2)
        .background(Color.customGray)
        .cornerRadius(10)
    }
    
    func clearRange() {
        isRangeStartSelected = true
        startRangeDate = nil
        endRangeDate = nil
    }
}

struct DateRangeSegments_Previews: PreviewProvider {
    static var previews: some View {
        DateRangeSegmentsView(isRangeStartSelected: .constant(true), startRangeDate: .constant(nil), endRangeDate: .constant(nil))
    }
}
