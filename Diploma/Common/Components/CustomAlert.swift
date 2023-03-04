import SwiftUI

enum AlertType : String {
    case info = "Подсказка"
    case error = "Ошибка"
    case success = "Успех"
}

struct CustomAlert: View {
    private let description: String
    private let icon: Image
    private let primaryColor: Color
    
    init(type: AlertType, description: String) {
        self.description = description
        switch type {
        case .info:
            icon = .customInfoAlert
            primaryColor = .customBlue
        case .error:
            icon = .customErrorAlert
            primaryColor = .customRed
        case .success:
            icon = .customSuccessAlert
            primaryColor = .customGreen
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            icon
                .resizable()
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(description).font(.customStandard)
                Text("hint").font(.customStandard).foregroundColor(primaryColor)
            }
            
            Spacer()
            Button {
                print("dismiss")
            } label: {
                Image.customPlus
                    .foregroundColor(primaryColor)
                    .rotationEffect(.degrees(45))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.customWhite)
        .cornerRadius(32)
        .bottomShadow()
        .padding(.horizontal, 24)
    }
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(type: .error, description: "error")
        CustomAlert(type: .success, description: "success")
        CustomAlert(type: .info, description: "info")
    }
}
