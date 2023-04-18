import SwiftUI

struct BarCharItem: Identifiable {
    static let empty = BarCharItem(value: "none", name: "none", percent: 1)
    
    let id = UUID()
    let value: String
    let name: String
    let percent: Double
}

struct Bar: View {
    var data: ChartDataWrapper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(data.name).font(.customHint).foregroundColor(.customOrange)
            
            Color.clear
            .frame(height: 16)
            .background(
                GeometryReader { geo in
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.customLightOrange)
                            .frame(width: (geo.size.width - 56) * data.percent)
                    
                        Text("\(Int(data.percent * 100))%")
                            .font(.customStandard)
                            .frame(width: 56)
                        
                        Spacer()
                    }
                })
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

struct BarChart: View {
    @ObservedObject var chartDataObj: ChartDataContainer
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(chartDataObj.chartData) { data in
                HStack {
                    Bar(data: data)
                    Spacer()
                }
            }
        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(chartDataObj: ChartDataContainer([ChartData(name: "product 1", value: 100),
                                                   ChartData(name: "product 2", value: 55),
                                                   ChartData(name: "product 3", value: 32),
                                                   ChartData(name: "product 4", value: 67)]))
    }
}
