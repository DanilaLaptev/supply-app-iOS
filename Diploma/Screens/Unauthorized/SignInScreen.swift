import SwiftUI

struct SignInScreen: View {
    var body: some View {
        VStack {
            Spacer()
            BottomSheet {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Вход в аккаунт").font(.customTitle)
                        .padding(.bottom, 8)
                    
                    CustomTextField(placeholder: "Логин")
                    CustomTextField(placeholder: "Пароль")
                        .padding(.bottom, 24)
                    
                    VStack(alignment: .center, spacing: 8) {
                        CustomButton(label: Text("Войти"))
                        Text("Создать аккаунт").font(.customStandard)
                            .foregroundColor(.customOrange)	
                    }
                }
            }
        }
        .background(Color.customLightGray)
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
