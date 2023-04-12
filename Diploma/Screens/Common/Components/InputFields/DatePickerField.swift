
import SwiftUI

struct DatePickerField: View {
    @Binding var date: Date
    @State private var contentVisible = false
    
    var icon: Image? = nil
    var background: Color = .clear
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            DatePicker(
                selection: $date,
                displayedComponents: [.date, .hourAndMinute]
            ) {
                icon?
                    .frame(width: 24, height: 24)
                    .foregroundColor(.customOrange)
            }
            .environment(\.locale, Locale.init(identifier: "ru"))
            .accentColor(.customOrange)
            .background(Color.clear)
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 16)
        .frame(height: 48)
        .background(background.cornerRadius(8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.customDarkGray, lineWidth: 1)
        )
    }
}

struct DatePickerField_Previews: PreviewProvider {
    @State static var date = Date()
    static var previews: some View {
        DatePickerField(date: $date, icon: .customDate)
        DatePickerField(date: $date)
    }
}
