import SwiftUI

struct MainSignUpView: View {
    public static let tag = "SignUpScreen"
    @State private var tagSelection: String? = nil
    
    
    
    var body: some View {
        VStack {
            NavigationLink("", destination: ContactsScreen(), tag: ContactsScreen.tag, selection: $tagSelection)
            
            Spacer()
            BottomSheet {
                VStack(alignment: .leading, spacing: 8) {
                    Header(title: "Основное")
                    
                    CustomTextField(textFieldValue: .constant(""), placeholder: "Роль")
                    CustomTextField(textFieldValue: .constant(""), placeholder: "Название организации")
                    CustomTextField(textFieldValue: .constant(""), placeholder: "Почта")
                    CustomTextField(textFieldValue: .constant(""), placeholder: "Пароль")
                    CustomTextField(textFieldValue: .constant(""), placeholder: "Подтверхдение пароля")
                        .padding(.bottom, 24)
                    
                    CustomButton(label: Text("Продолжить")) { tagSelection = ContactsScreen.tag }
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
            MainSignUpView()
        }
    }
}
