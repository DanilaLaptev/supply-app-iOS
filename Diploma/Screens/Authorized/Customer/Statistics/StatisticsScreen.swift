import SwiftUI

struct StatisticsScreen: View {
    public static let tag = "StatisticsScreen"
    
    @EnvironmentObject private var tools: ViewTools
    
    @State private var isSharePresented: Bool = false
    
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
                CalendarView()
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

struct StatisticsScreen_Previews: PreviewProvider {
    @StateObject static var viewTools = ViewTools()
    
    static var previews: some View {
        NavigationView {
            StatisticsScreen()
                .environmentObject(viewTools)
        }
    }
}
