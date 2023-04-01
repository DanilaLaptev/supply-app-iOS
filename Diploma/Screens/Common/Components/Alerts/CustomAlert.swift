import SwiftUI

enum AlertType : String {
    case info = "Подсказка"
    case error = "Ошибка"
    case success = "Успех"
}

struct CustomAlert: View {
    private var alertsManager = AlertManager.shared
    @State private var autoDismissTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    private let model: AlertModel
    private let icon: Image
    private let primaryColor: Color
    
    init(_ alertModel: AlertModel) {
        self.model = alertModel
        switch alertModel.type {
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
                Text(model.description).font(.customStandard)
                Text("hint").font(.customStandard).foregroundColor(primaryColor)
            }
            
            Spacer()
            Button {
                alertsManager.removeAlert(model)
            } label: {
                Image.customPlus
                    .frame(width: 16, height: 16)
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
        .onReceive(autoDismissTimer) { _ in
            alertsManager.removeAlert(model)
        }
    }
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(AlertModel(type: .error, description: "error"))
        CustomAlert(AlertModel(type: .success, description: "success"))
        CustomAlert(AlertModel(type: .info, description: "info"))
    }
}
