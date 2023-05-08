import SwiftUI
import Combine

struct SupplierStatisticsView: View {
    public static let tag = "SupplierStatisticsView"

    @StateObject private var tools = ViewManager.shared
    
    @State private var isSharePresented: Bool = false
    
    @State var startDate: Date? = nil
    @State var endDate: Date? = nil
    
    @StateObject private var viewModel = SupplierStatisticsViewModel()
    
    private var incomingStatisticsSubtitle: String {
        "Общая стоимость: \(viewModel.incomingStatistics.chartData.map { Int($0.value) }.reduce(0, +)) ₽"
    }
    
    private var outcomingStatisticsSubtitle: String {
        "Общая стоимость: \(viewModel.outcomingStatistics.chartData.map { Int($0.value) }.reduce(0, +)) ₽"
    }
    
    var statistic: URL? {
        let csvBulderResult = FileManager.shared.exportCSV(
            fileName: viewModel.dateRangeTitle,
            dataArray: [
                StatisticModel(product: "apple", price: 50, ammount: 34),
                StatisticModel(product: "banana", price: 70, ammount: 41),
                StatisticModel(product: "potato", price: 40, ammount: 300)
            ])
        
        if case .success(let filePath) = csvBulderResult {
            return filePath
        }
        return nil
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                CalendarView(startDate: $viewModel.startDate, endDate: $viewModel.endDate)
                    .padding(.bottom, 8)
                
                HStack {
                    Text(viewModel.dateRangeTitle).font(.customSubtitle)
                    Spacer()
                    CustomButton(icon: .customFile) {
                        isSharePresented = true
                    }
                    .frame(width: 48, height: 48)
                    .sheet(isPresented: $isSharePresented) {
                        ActivityViewController(activityItems: [statistic!])
                    }
                }
                
                ExtendableSection(isCollapsed: false) {
                    PieChart(chartDataObj: viewModel.incomingStatistics)
                } headerContent: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Купленные товары").font(.customSubtitle)
                        Text(incomingStatisticsSubtitle).font(.customHint)
                    }
                }
                
                ExtendableSection(isCollapsed: false) {
                    BarChart(chartDataObj: viewModel.outcomingStatistics)
                } headerContent: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Проданные товары").font(.customSubtitle)
                        Text(outcomingStatisticsSubtitle).font(.customHint)
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.top, safeAreaEdgeInsets.top)
            .padding(.bottom, safeAreaEdgeInsets.bottom)
        }
        .padding(.horizontal, 16)
        .background(Color.customLightGray)
        .defaultScreenSettings()
    }

}


struct SupplierStatisticsViewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierStatisticsView()
        }
    }
}
