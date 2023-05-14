import SwiftUI

struct ContactView: View {
    public static let tag = "ContactsScreen"
    
    @State private var tagSelection: String? = nil
    
    @StateObject private var viewModel = ContactViewModel()
    @EnvironmentObject private var newOrganization: OrganizationCreationModel
    
    var body: some View {
        
        OverflowScroll {
            NavigationLink(
                destination: OrganizationImageView().environmentObject(newOrganization),
                isActive: $viewModel.navigateToOrganizationImage,
                label: { }
            )

            VStack {
                Spacer()
                BottomSheet {
                    VStack(alignment: .leading, spacing: 8) {
                        Header(title: "Контактное лицо")
                        
                        CustomTextField(textFieldValue: $viewModel.fullName, placeholder: "ФИО")
                        CustomTextField(textFieldValue: $viewModel.phone, placeholder: "Номер телефона")
                        CustomTextField(textFieldValue: $viewModel.email, placeholder: "Электронная почта")
                            .autocapitalization(.none)
                            .padding(.bottom, 24)
                        
                        CustomButton(label: Text("Продолжить")) { viewModel.createOrganizationBranch() }
                    }
                }
            }
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            viewModel.setupOrganization(self.newOrganization)
        }
    }
}

struct ContactsScreen_Previews: PreviewProvider {
    @State static var data = OrganizationCreationModel()
    
    static var previews: some View {
        NavigationView {
            ContactView()
                .environmentObject(data)
        }
    }
}
