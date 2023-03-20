import SwiftUI

struct SignUpScreen: View {
    public static let tag = "SignUpScreen"
    
    @State private var tagSelection: String? = nil
    
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
                    
                    NavigationLink(destination: ContactsScreen(), tag: ContactsScreen.tag, selection: $tagSelection) {
                        CustomButton(label: Text("Продолжить")) { tagSelection = ContactsScreen.tag }
                    }
                }
            }
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpScreen()
        }
    }
}
