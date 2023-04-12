import SwiftUI

enum OrderDeliveryState {
    case current
    case passed
    case next
}

struct OrderStateCircle<Content: View>: View {
    var stepState: OrderDeliveryState
    var icon: Content
    
    init(
        stepState: OrderDeliveryState,
        @ViewBuilder icon: () -> Content
    ) {
        self.stepState = stepState
        self.icon = icon()
    }
    
    private var foreground: Color {
        switch stepState {
        case .current:
            return .customWhite
        case .passed:
            return .customOrange
        case .next:
            return .customDarkGray
        }
    }
    
    private var background: Color {
        switch stepState {
        case .current:
            return .customOrange
        case .passed:
            return .customLightOrange
        case .next:
            return .customGray
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(background)
                    .frame(width: 40, height: 40)
                
                icon
                    .frame(width: 24, height: 24)
                    .foregroundColor(foreground)
            }
        }
    }
}

struct OrderStateView: View {
    var stepState: OrderDeliveryState
    
    private var foreground: Color {
        switch stepState {
        case .current:
            return .customOrange
        case .passed:
            return .customLightOrange
        case .next:
            return .customGray
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                OrderStateCircle(stepState: stepState) {
                    Image.customRoute
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Доставлен").font(.customStandard)
                    Text("контактный номер").font(.customHint)
                }
                Spacer()
                Text("25 фев, 00:00")
                    .foregroundColor(.customDarkGray)
                    .font(.customHint)
            }
            HStack(spacing: 16) {
                Rectangle()
                    .frame(width: 2, height: 32)
                    .foregroundColor(foreground)
                    .padding(.leading, 19)
                
                Spacer()
            }
        }
    }
}

struct OrderStateStep_Previews: PreviewProvider {
    static var previews: some View {
        OrderStateView(stepState: .passed)
        OrderStateView(stepState: .next)
        OrderStateView(stepState: .current)

        VStack(spacing: 0) {
            OrderStateView(stepState: .current)
            OrderStateView(stepState: .passed)
            OrderStateView(stepState: .passed)
        }
    }
}
