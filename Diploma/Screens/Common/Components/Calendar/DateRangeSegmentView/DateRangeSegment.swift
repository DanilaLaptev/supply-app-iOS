import SwiftUI

struct DateRangeSegment: View {
    @Binding var selectedDate: Date?
    @Binding var isSelected: Bool
    
    var title: String = "Title"
    var onTap: (() -> ())? = nil
    var onDismiss: (() -> ())? = nil
    
    var valueColor: Color {
        if selectedDate == nil {
            return .customDarkGray
        }
        
        if isSelected {
            return .customOrange
        }
        
        return .customBlack
    }
    
    private var selectedDateLabel: String? {
        guard let date = selectedDate else { return nil }
        return DateFormatManager.shared.getFormattedString(date, dateFormat: "MMM d, yyyy")
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.customStandard)
                    .foregroundColor(.customBlack)
                Text(selectedDateLabel ?? "select")
                    .font(.customHint)
                    .foregroundColor(valueColor)
            }
            Spacer()
            if isSelected && selectedDate != nil {
                CustomSmallButton(icon: .customPlus, background: .customDarkGray) {
                    onDismiss?()
                }
                .rotationEffect(.degrees(45))
                .frame(width: 24, height: 24)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(isSelected ? Color.customWhite : Color.customGray)
        .cornerRadius(8)
        .onTapGesture {
            onTap?()
        }
    }
}

struct DateRangeSegment_Previews: PreviewProvider {
    static var previews: some View {
        DateRangeSegment(selectedDate: .constant(nil), isSelected: .constant(true))
    }
}
