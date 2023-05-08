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
    var supplyHistory: SupplyStatusHistory
    
    
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
                Rectangle()
                    .frame(width: 2, height: 32)
                    .foregroundColor(foreground)
                    .padding(.leading, 19)
                
                Spacer()
            }
            HStack(spacing: 16) {
                OrderStateCircle(stepState: stepState) {
                    supplyHistory.status.icon
                }
                
                Text(supplyHistory.status.name).font(.customStandard)
                Spacer()
                Text(supplyHistory.created?.toString("dd MMM, HH:mm") ?? "-- ---, --:--")
                    .foregroundColor(.customDarkGray)
                    .font(.customHint)
            }
        }
    }
}

struct OrderStateStep_Previews: PreviewProvider {
    static var previews: some View {
        OrderStateView(stepState: .passed, supplyHistory: .init(status: .pending, created: Date()))
        OrderStateView(stepState: .next, supplyHistory: .init(status: .pending, created: Date()))
        OrderStateView(stepState: .current, supplyHistory: .init(status: .pending, created: Date()))

        VStack(spacing: 0) {
            OrderStateView(stepState: .current, supplyHistory: .init(status: .pending, created: Date()))
            OrderStateView(stepState: .passed, supplyHistory: .init(status: .pending, created: Date()))
            OrderStateView(stepState: .passed, supplyHistory: .init(status: .pending, created: Date()))
        }
    }
}
