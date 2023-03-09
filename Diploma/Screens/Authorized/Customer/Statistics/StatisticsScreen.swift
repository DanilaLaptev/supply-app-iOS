import SwiftUI

struct StatisticsScreen: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                CustomCalendar()
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
    }
}

struct StatisticsScreen_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsScreen()
    }
}
