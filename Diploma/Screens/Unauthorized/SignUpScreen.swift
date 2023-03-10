import SwiftUI

struct SignUpScreen: View {
    var body: some View {
        VStack {
            Spacer()
            BottomSheet {
                VStack(alignment: .leading, spacing: 8) {
                    Header()
                    
                    CustomTextField(placeholder: "Роль")
                    CustomTextField(placeholder: "Название организации")
                    CustomTextField(placeholder: "Логин")
                    CustomTextField(placeholder: "Пароль")
                    CustomTextField(placeholder: "Подтверхдение пароля")
                        .padding(.bottom, 24)
                    
                    CustomButton(label: Text("Продолжить"))
                }
            }
        }
        .background(Color.customLightGray)
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
