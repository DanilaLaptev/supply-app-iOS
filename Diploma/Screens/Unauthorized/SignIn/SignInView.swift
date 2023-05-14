import SwiftUI

struct SignInView: View {
    public static let tag = "SignInScreen"
    
    @StateObject private var viewModel = SignInViewModel()
    @StateObject private var viewManager = ViewManager.shared
    
    var body: some View {
        OverflowScroll {
            VStack {
                NavigationLink(
                    destination: SupplierMainScreen(),
                    isActive: $viewModel.navigateToSupplierMain,
                    label: { }
                )
                
                NavigationLink(
                    destination: WorkerMainView(),
                    isActive: $viewModel.navigateToWorkerMain,
                    label: { }
                )
                
                NavigationLink(
                    destination: MainSignUpView(),
                    isActive: $viewModel.navigateToSignUp,
                    label: { }
                )

                Spacer()
                BottomSheet {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Вход в аккаунт").font(.customTitle)
                            .padding(.bottom, 8)
                        
                        CustomTextField(textFieldValue: $viewModel.email, placeholder: "Логин")
                            .autocapitalization(.none)
                        CustomTextField(textFieldValue: $viewModel.password, placeholder: "Пароль", isSecure: true)
                            .autocapitalization(.none)
                            .padding(.bottom, 24)
                        
                        VStack(alignment: .center, spacing: 8) {
                            CustomButton(label: Text("Войти")) {
                                self.viewModel.signInOrganization()
                            }
                            
                            Text("Создать аккаунт").font(.customStandard)
                                .foregroundColor(.customOrange)
                                .onTapGesture {
                                    viewModel.navigateToSignUp.toggle()
                                }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .loadingWrapper($viewManager.isLoading)
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
        }
    }
}
