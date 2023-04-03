import SwiftUI

struct MainSignUpView: View {
    public static let tag = "SignUpScreen"
    @State private var tagSelection: String? = nil
    
    @StateObject private var newOrganizationData = OrganizationCreationModel()
    
    var body: some View {
        OverflowScroll {
            VStack {
                NavigationLink("", destination: ContactView(), tag: ContactView.tag, selection: $tagSelection)
                
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
                        
                        CustomButton(label: Text("Продолжить")) { tagSelection = ContactView.tag }
                    }
                }
            }
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .environmentObject(newOrganizationData)
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainSignUpView()
        }
    }
}
