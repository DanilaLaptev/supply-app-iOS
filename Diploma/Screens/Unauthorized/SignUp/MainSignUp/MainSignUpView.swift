import SwiftUI

struct MainSignUpView: View {
    public static let tag = "SignUpScreen"
    
    @StateObject private var viewModel = MainSignUpViewModel()
    
    var body: some View {
        OverflowScroll {
            VStack {
                NavigationLink(
                    destination: ContactView().environmentObject(viewModel.organization),
                    isActive: $viewModel.navigateToContactView,
                    label: { }
                )

                Spacer()
                BottomSheet {
                    VStack(alignment: .leading, spacing: 8) {
                        Header(title: "Основное")
                        
                        DropDownList(
                            placeholder: "Тип",
                            items: OrganizationType.allCases.map { $0.name } ,
                            selected: $viewModel.role
                        )
                        CustomTextField(textFieldValue: $viewModel.organizationName, placeholder: "Название организации")
                        CustomTextField(textFieldValue: $viewModel.email, placeholder: "Почта")
                            .autocapitalization(.none)
                        
                        CustomTextField(textFieldValue: $viewModel.password, placeholder: "Пароль", isSecure: true)
                        CustomTextField(textFieldValue: $viewModel.repeatedPassword, placeholder: "Подтверхдение пароля", isSecure: true)
                            .padding(.bottom, 24)
                        
                        CustomButton(label: Text("Продолжить")) { viewModel.signUpOrganization() }
                    }
                }
            }
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .environmentObject(viewModel.organization)
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainSignUpView()
        }
    }
}
