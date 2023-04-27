import SwiftUI

struct RadioButton: View {
    var selected: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .stroke(Color.customOrange, lineWidth: 1)
                .frame(width: 18, height: 18)
            if selected {
                Circle()
                    .foregroundColor(.customOrange)
                    .frame(width: 10)
            }
        }
    }
}

struct RadioButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RadioButton(selected: true)
            RadioButton(selected: false)
        }
    }
}
