import SwiftUI

struct StatisticsScreen: View {
    public static let tag = "StatisticsScreen"
    
    @EnvironmentObject private var tools: ViewTools
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                CalendarView()
                    .padding(.bottom, 8)
                
                HStack {
                    Text("Статистика за 25 фев - 29 фев").font(.customSubtitle)
                    Spacer()
                    CustomButton(icon: .customFile)
                        .frame(width: 48, height: 48)
                }
                
                ExtendableSection {
                    PieChart()
                } headerContent: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Доступная продукция").font(.customSubtitle)
                        Text("Напитки, выпечка").font(.customHint)
                    }
                }
                
                ExtendableSection {
                    PieChart()
                } headerContent: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Доступная продукция").font(.customSubtitle)
                        Text("Напитки, выпечка").font(.customHint)
                    }
                }
                
            }
            .padding(.vertical, 8)
            .padding(.top, safeAreaEdgeInsets.top)
        }
        .padding(.horizontal, 16)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            tools.setBottomBarVisibility(true)
        }
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
