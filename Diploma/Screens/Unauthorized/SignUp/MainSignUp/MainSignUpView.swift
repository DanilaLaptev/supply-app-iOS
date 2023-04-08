import SwiftUI

struct MainSignUpView: View {
    public static let tag = "SignUpScreen"
    @State private var tagSelection: String? = nil
    
    @StateObject private var newOrganizationData = OrganizationCreationModel()
    @StateObject private var viewModel = MainSignUpViewModel()
    
    var body: some View {
        OverflowScroll {
            VStack {
                NavigationLink("", destination: ContactView(), tag: ContactView.tag, selection: $tagSelection)
                
                Spacer()
                BottomSheet {
                    VStack(alignment: .leading, spacing: 8) {
                        Header(title: "Основное")
                        
                        DropDownList(
                            placeholder: "Тип организации",
                            items: OrganizationType.allCases.map { $0.rawValue } ,
                            selected: $viewModel.role
                        )
                        CustomTextField(textFieldValue: $viewModel.organizationName, placeholder: "Название организации")
                        CustomTextField(textFieldValue: $viewModel.email, placeholder: "Почта")
                        CustomTextField(textFieldValue: $viewModel.password, placeholder: "Пароль", isSecure: true)
                        CustomTextField(textFieldValue: $viewModel.repeatedPassword, placeholder: "Подтверхдение пароля", isSecure: true)
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
