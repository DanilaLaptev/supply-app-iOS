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
                    HStack {
                        CustomButton(icon: .customReload, isCircleShape: true) {
                            viewModel.refreshData()
                        }
                        .frame(width: 48)
                        SmallTagsGroup<SupplyStatus>(selectedTags: $viewModel.supplyStatuses)
                            .padding(.top, 8)
                            .padding(.bottom, 16)
                    }
                    .padding(.leading, 16)
                }
                
                VStack(alignment: .center) {
                    if viewModel.supplies.isEmpty {
                        ListEmptyView()
                    }
                    
                    ForEach(viewModel.supplies) { supply in
                        NavigationLink {
                            SupplyScreen(supplyModel: supply)
                        } label: {
                            SupplyCard(supplyModel: supply)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.horizontal, .bottom], 16)
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
