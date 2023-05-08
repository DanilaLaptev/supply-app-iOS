import SwiftUI

struct SupplyHistoryList: View {
    let history: [SupplyStatusHistory]

    private let list = SupplyStatus.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(list, id: \.self) { status in
                OrderStateView(
                    stepState: getStatusState(status),
                    supplyHistory: SupplyStatusHistory(status: status, created: getStatusTime(status))
                )
            }
        }
    }
    
    private func getStatusTime(_ status: SupplyStatus) -> Date? {
        history.first(where: { $0.status == status})?.created
    }
    
    private func getStatusState(_ status: SupplyStatus) -> OrderDeliveryState {
        if history.last?.status == status {
            return .current
        }
        
        if history.contains(where: { $0.status == status }) {
            return .passed
        }
        
        return .next
    }
}

struct SupplyHistoryList_Previews: PreviewProvider {
    static var previews: some View {
        SupplyHistoryList(history: [])
    }
}
