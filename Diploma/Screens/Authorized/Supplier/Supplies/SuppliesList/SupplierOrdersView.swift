import SwiftUI
import Combine

struct SupplierOrdersView: View {
    public static let tag = "SupplierOrdersView"
    
    @StateObject private var tools = ViewManager.shared
    
    @StateObject private var viewModel = SupplierOrdersViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                CalendarView(startDate: $viewModel.startDate, endDate: $viewModel.endDate)
                    .padding([.horizontal, .bottom], 16)
                
                Text(viewModel.dateRangeTitle)
                    .font(.customSubtitle)
                    .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        CustomButton(icon: .customReload, isCircleShape: true) {
                            viewModel.refreshData()
                        }
                        .frame(width: 48)
                        SmallTagsGroup<SupplyStatus>(selectedTags: $viewModel.supplyStatuses)
                    }

                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }
                
                VStack {
                    ForEach(viewModel.supplies) { supply in
                        NavigationLink {
                            SupplierOrderView(supplyModel: supply)
                        } label: {
                            SupplyCard(supplyModel: supply)
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

struct SupplierOrdersViewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierOrdersView()
        }
    }
}
