import SwiftUI

struct ContactView: View {
    public static let tag = "ContactsScreen"
    
    @State private var tagSelection: String? = nil
    @EnvironmentObject private var newOrganizationData: OrganizationCreationModel
    
    @StateObject private var viewModel = ContactViewModel()
    
    var body: some View {
        
        OverflowScroll {
            VStack {
                Spacer()
                BottomSheet {
                    VStack(alignment: .leading, spacing: 8) {
                        Header(title: "Контактное лицо")

                        CustomTextField(textFieldValue: .constant(""), placeholder: "ФИО")
                        CustomTextField(textFieldValue: .constant(""), placeholder: "Номер телефона")
                        CustomTextField(textFieldValue: .constant(""), placeholder: "Электронная почта")
                            .padding(.bottom, 24)
                        
                        NavigationLink(destination: LocationView(), tag: LocationView.tag, selection: $tagSelection) {
                            CustomButton(label: Text("Продолжить")) { tagSelection = LocationView.tag }
                        }
                    }
                }
            }
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
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
