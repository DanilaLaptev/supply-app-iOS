import SwiftUI

struct ContactsScreen: View {
    var body: some View {
        VStack {
            Spacer()
            BottomSheet {
                VStack(alignment: .leading, spacing: 8) {
                    Header()
                    
                    CustomTextField(placeholder: "ФИО")
                    CustomTextField(placeholder: "Номер телефона")
                    CustomTextField(placeholder: "Электронная почта")
                        .padding(.bottom, 24)
                    
                    CustomButton(label: Text("Продолжить"))
                }
            }
        }
        .background(Color.customLightGray)
    }
}

struct ContactsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContactsScreen()
    }
}
