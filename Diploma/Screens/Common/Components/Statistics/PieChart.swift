import SwiftUI

struct PieChart: View {
    @ObservedObject var charDataObj: ChartDataContainer
    
    @State private var indexOfTappedSlice: Int?
    var body: some View {
        HStack() {
            ZStack {
                ForEach(0..<charDataObj.chartData.count) { index in
                    Circle()
                        .trim(from: index == 0 ? 0.0: charDataObj.chartData[index-1].offset,
                              to: charDataObj.chartData[index].offset)
                        .stroke(charDataObj.chartData[index].color, lineWidth: 24)
                        .onTapGesture {
                            indexOfTappedSlice = indexOfTappedSlice == index ? nil: index
                        }
                        .scaleEffect(index == indexOfTappedSlice ? 1.1: 1)
                        .animation(.spring())
                }
                if let indexOfTappedSlice {
                    Text("\(Int(charDataObj.chartData[indexOfTappedSlice].percent * 100))%")
                        .font(.customSubtitle)
                }
            }
            .frame(width: 96, height: 96)
            
            Spacer()
            
            VStack(alignment: .leading) {
                ForEach(0..<charDataObj.chartData.count) { index in
                    HStack(spacing: 8) {
                        VStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(charDataObj.chartData[index].color)
                                .frame(width: 24, height: 8)
                            
                            Text(charDataObj.chartData[index].name)
                                .font(indexOfTappedSlice == index ? .customSubtitle: .customStandard)
                        }
                        Text("\(Int(charDataObj.chartData[index].percent * 100))%")
                            .font(indexOfTappedSlice == index ? .customSubtitle: .customHint)
                    }
                    .onTapGesture {
                        indexOfTappedSlice = indexOfTappedSlice == index ? nil: index
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
    }
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart(charDataObj: ChartDataContainer([ChartData(name: "product 1", value: 100),
                                                  ChartData(name: "product 2", value: 55),
                                                  ChartData(name: "product 3", value: 32),
                                                  ChartData(name: "product 4", value: 67)]))
    }
}
