import SwiftUI

struct OrderingView: View {
    public static let tag = "OrderingView"
        
    @StateObject private var tools = ViewManager.shared
    @ObservedObject private var viewModel: OrderingViewModel

    @State var date = Date()
    
    init(organizationModel: OrganizationModel) {
        self.viewModel = OrderingViewModel(organizationModel: organizationModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Header(title: "Оформление заказа")
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(viewModel.organizationModel.storageItems.count) продуктов")
                            .font(.customTitle)
                            .padding(.horizontal, 16)
                        Spacer()
                    }
                    
                    VStack {
                        ForEach(viewModel.organizationModel.storageItems) { storageItem in
                            StaticProductCard(storageItem: storageItem)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            
            BottomSheet {
                VStack(spacing: 32) {
                    VStack(alignment: .leading ,spacing: 16) {
                        Text("Выберите дату и время получения заказа").font(.customStandard)
                        VStack(spacing: 8) {
                            DatePickerField(date: $date, icon: .customDate)
                        }
                    }
                    
                    CustomButton(label: Text("Оформить заказ на \(Int(viewModel.totalPrice)) ₽"))
                }
                .padding(.vertical, 8)
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = false
        }
    }
}

struct OrderingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OrderingView(organizationModel: .empty)
        OrderingView(organizationModel: .test)
    }
}
