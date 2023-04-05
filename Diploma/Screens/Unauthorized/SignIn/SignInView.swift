import SwiftUI

struct SignInView: View {
    public static let tag = "SignInScreen"
    
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        OverflowScroll {
            VStack {
                NavigationLink("", destination: SupplierTabBarWrapper(), tag: SupplierTabBarWrapper.tag, selection: $viewModel.nextScreenTag)
                NavigationLink("", destination: CustomerTabBarWrapper(), tag: CustomerTabBarWrapper.tag, selection: $viewModel.nextScreenTag)
                NavigationLink("", destination: MainSignUpView(), tag: MainSignUpView.tag, selection: $viewModel.nextScreenTag)
                
                Spacer()
                BottomSheet {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Вход в аккаунт").font(.customTitle)
                            .padding(.bottom, 8)
                        
                        DropDownList(
                            placeholder: "Тип организации",
                            items: OrganizationType.allCases.map { $0.rawValue } ,
                            selected: $viewModel.role
                        )
                        CustomTextField(textFieldValue: $viewModel.email, placeholder: "Логин")
                        CustomTextField(textFieldValue: $viewModel.password, placeholder: "Пароль", isSecure: true)
                            .padding(.bottom, 24)
                        
                        VStack(alignment: .center, spacing: 8) {
                            CustomButton(label: Text("Войти")) {
                                self.viewModel.tapSignInButton.toggle()
                            }
                            
                            Text("Создать аккаунт").font(.customStandard)
                                .foregroundColor(.customOrange)
                                .onTapGesture {
                                    viewModel.nextScreenTag = MainSignUpView.tag
                                }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
        }
    }
}
