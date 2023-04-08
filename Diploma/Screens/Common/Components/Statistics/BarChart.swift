import SwiftUI

struct BarCharItem: Identifiable {
    static let empty = BarCharItem(value: "none", name: "none", percent: 1)
    
    let id = UUID()
    let value: String
    let name: String
    let percent: Double
}

struct Bar: View {
    var model: BarCharItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.name).font(.customHint).foregroundColor(.customOrange)
            
            Color.clear
            .frame(height: 16)
            .background(
                GeometryReader { geo in
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.customLightOrange)
                            .frame(width: (geo.size.width - 56) * model.percent)
                    
                        Text("\(Int(model.percent * 100))%")
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
    let bars = [
        BarCharItem(value: "$100", name: "product 1", percent: 0.5),
        BarCharItem(value: "$250", name: "product 2", percent: 0.9),
        BarCharItem(value: "$250", name: "product 2", percent: 1),
        BarCharItem(value: "$200", name: "product 3", percent: 0.8)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(bars) { bar in
                HStack {
                    Bar(model: bar)
                    Spacer()
                }
            }
        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart()
    }
}
