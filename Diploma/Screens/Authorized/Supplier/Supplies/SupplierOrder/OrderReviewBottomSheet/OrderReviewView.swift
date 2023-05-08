import SwiftUI
import Combine

struct OrderReviewView: View {
    public static let tag = "OrderReviewView"
    
    let supplyModel: SupplyModel
    @StateObject private var viewModel = OrderReviewViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Header(title: "Рассмотрение заказа")
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Причина отказа").font(.customSubtitle)
                    .padding(.bottom, 16)
                
                RadioButtonGroup<RejectionItem>(items: viewModel.rejectionReasonsList, selected: $viewModel.selectedRejectionReason)
                
                HStack(spacing: 16) {
                    Button {
                        viewModel.declineSupply()
                    } label: {
                        Text("Отклонить")
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .foregroundColor(.customOrange)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.customOrange, lineWidth: 1)
                            )
                    }
                    
                    CustomButton(label: Text("Одобрить")) {
                        viewModel.acceptSupply()
                    }
                }
                .padding(.top, 48)
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.top, 24)
        .onAppear {
            viewModel.setup(supplyModel)
        }
    }
}

struct OrderReviewViewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderReviewView(supplyModel: .empty)
        }
    }
}
