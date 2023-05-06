import SwiftUI

struct ProfileView: View {
    public static let tag = "ProfileScreen"
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(imageUrl: URL(string: "https://avatars.mds.yandex.net/get-altay/7740052/2a000001834d1a593948fb37e2811815989f/XXL_height")) {
                Color.customDarkGray
            }
            .clipShape(Circle())
            .padding(.bottom, 32)
            .frame(height: UIScreen.main.bounds.width * 0.5)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Основная информация").font(.customTitle).padding(.bottom, 8)
                    Text("Название: \(viewModel.organizationInfo?.title ?? "-")").font(.customStandard)
                    Text("Тип организации: \(viewModel.organizationInfo?.organizationType?.name ?? "-")").font(.customStandard)
                    Text("Адрес: \(viewModel.organizationInfo?.mainBranch?.address?.addressName ?? "-")").font(.customStandard)
                }
                Spacer()
            }
            .padding(16)
            .background(Color.customWhite)
            .cornerRadius(8)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Контакты").font(.customTitle).padding(.bottom, 8)
                    Text("ФИО: \(viewModel.organizationInfo?.mainContact?.fullName ?? "-")").font(.customStandard)
                    Text("Телефон: \(viewModel.organizationInfo?.mainContact?.phone ?? "-")").font(.customStandard)
                    Text("Почта: \(viewModel.organizationInfo?.mainContact?.email ?? "-")").font(.customStandard)
                }
                Spacer()
            }
            .padding(16)
            .background(Color.customWhite)
            .cornerRadius(8)
            
            Spacer()
            
            CustomButton(label: Text("Выйти")) {
                authManager.clearData()
            }
        }
        .padding(.horizontal ,16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, safeAreaEdgeInsets.top)
        .padding(.bottom, safeAreaEdgeInsets.bottom)
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
