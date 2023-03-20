import SwiftUI

struct Counter: View {
    @State var counterValue = 0
    
    private let minimum = 0
    private let maximum = 100

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            CustomSmallButton(icon: .customMinus,
                              background: .customWhite,
                              foregroundColor: .customOrange) {
                counterValue -= 1
            }
            .disabled(counterValue <= minimum)

            Text("\(counterValue)")
                .font(.customStandard)
                .foregroundColor(.customBlack)
                .frame(width: 26)
            
            CustomSmallButton(icon: .customPlus) {
                counterValue += 1
            }
            .disabled(counterValue >= maximum)
        }
        .padding(2)
        .background(Color.customLightGray)
        .cornerRadius(.infinity)
    }
}

struct Counter_Previews: PreviewProvider {
    static var previews: some View {
        Counter()
    }
}
