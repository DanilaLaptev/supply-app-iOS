import SwiftUI
import Combine

struct OrderReviewView: View {
    public static let tag = "OrderReviewView"
    
    @StateObject var viewModel = OrderReviewViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Header(title: "Рассмотрение заказа")
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Причина отказа").font(.customSubtitle)
                    .padding(.bottom, 16)
                
                ForEach(viewModel.rejectionReasonsList) { rejectionModel in
                    HStack(alignment: .top) {
                        RadioButton(selected: rejectionModel.selected)
                        Text(rejectionModel.name).font(.customStandard)
                    }
                    .onTapGesture {
                        viewModel.selectReason(rejectionModel.id)
                    }
                }
                
                HStack(spacing: 16) {
                    Button {
                        
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
                    
                    CustomButton(label: Text("Одобрить"))
                }
                .padding(.top, 48)
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.top, 24)
    }
}

struct OrderReviewViewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderReviewView()
        }
    }
}
