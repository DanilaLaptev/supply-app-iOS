import SwiftUI
import Combine

struct SupplierStatisticsView: View {
    public static let tag = "SupplierStatisticsView"
    
    @StateObject var viewModel = SupplierStatisticsViewModel()
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var isSharePresented: Bool = false
    
    @State var startDate: Date? = Date()
    @State var endDate: Date? = Calendar(identifier: .gregorian).date(byAdding: .day, value: 7, to: Date())

    var statistic: URL? {
        let csvBulderResult = FileManager.shared.exportCSV(dataArray: [
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
                CalendarView(startDate: $startDate, endDate: $endDate)
                    .padding(.bottom, 8)
                
                HStack {
                    Text("Статистика за 25 фев - 29 фев").font(.customSubtitle)
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
                    PieChart()
                } headerContent: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Доступная продукция").font(.customSubtitle)
                        Text("Напитки, выпечка").font(.customHint)
                    }
                }
                
                ExtendableSection(isCollapsed: false) {
                    BarChart()
                } headerContent: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Доступная продукция").font(.customSubtitle)
                        Text("Напитки, выпечка").font(.customHint)
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
