import SwiftUI

struct SignInScreen: View {
    public static let tag = "SignInScreen"
    
    @State private var tagSelection: String? = nil
    
    var body: some View {
        VStack {
            NavigationLink("", destination: SupplierTabBarWrapper(), tag: SupplierTabBarWrapper.tag, selection: $tagSelection)
            NavigationLink("", destination: CustomerTabBarWrapper(), tag: CustomerTabBarWrapper.tag, selection: $tagSelection)
            NavigationLink("", destination: SignUpScreen(), tag: SignUpScreen.tag, selection: $tagSelection)
            
            Spacer()
            BottomSheet {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Вход в аккаунт").font(.customTitle)
                        .padding(.bottom, 8)
                    
                    CustomTextField(placeholder: "Логин")
                    CustomTextField(placeholder: "Пароль")
                        .padding(.bottom, 24)
                    
                    VStack(alignment: .center, spacing: 8) {
                        CustomButton(label: Text("Войти")) { tagSelection = CustomerTabBarWrapper.tag }
                        CustomButton(label: Text("Войти (Supplier)")) { tagSelection = SupplierTabBarWrapper.tag }
                        
                        Text("Создать аккаунт").font(.customStandard)
                            .foregroundColor(.customOrange)
                            .onTapGesture { tagSelection = SignUpScreen.tag }
                    }
                }
            }
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInScreen()
        }
    }
}
