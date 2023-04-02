import SwiftUI

struct ContactsScreen: View {
    public static let tag = "ContactsScreen"
    
    @State private var tagSelection: String? = nil
    
    var body: some View {
        VStack {
            Spacer()
            BottomSheet {
                VStack(alignment: .leading, spacing: 8) {
                    Header(title: "Контактное лицо")

                    CustomTextField(textFieldValue: .constant(""), placeholder: "ФИО")
                    CustomTextField(textFieldValue: .constant(""), placeholder: "Номер телефона")
                    CustomTextField(textFieldValue: .constant(""), placeholder: "Электронная почта")
                        .padding(.bottom, 24)
                    
                    NavigationLink(destination: LocationScreen(), tag: LocationScreen.tag, selection: $tagSelection) {
                        CustomButton(label: Text("Продолжить")) { tagSelection = LocationScreen.tag }
                    }
                }
            }
        }
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }
}

struct ContactsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactsScreen()
        }
    }
}
