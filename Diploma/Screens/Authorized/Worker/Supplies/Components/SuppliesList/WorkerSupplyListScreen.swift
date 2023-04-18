import SwiftUI

struct WorkerSupplyListScreen: View {
    public static let tag = "OrdersListScreen"
    
    @StateObject private var tools = ViewManager.shared
    
    @StateObject private var viewModel = WorkerSuppliesListViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                CalendarView(startDate: $viewModel.startDate, endDate: $viewModel.endDate)
                    .padding([.horizontal, .bottom], 16)
                
                Text(viewModel.dateRangeTitle)
                    .font(.customSubtitle)
                    .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    TagsGroup<SupplyProcessingStatus>()
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }
                
                VStack {
                    ForEach((0...8), id: \.self) { _ in
                        NavigationLink {
                            SupplyScreen(supplyModel: .empty)
                        } label: {
                            SupplyCard(supplyModel: .empty)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 8)
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = true
        }
    }
}

struct OrdersScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkerSupplyListScreen()
        }
    }
}
