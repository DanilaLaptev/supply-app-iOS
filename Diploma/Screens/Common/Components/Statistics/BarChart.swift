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
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.name).font(.customHint).foregroundColor(.customOrange)
                Text(model.value).font(.customStandard).foregroundColor(.customOrange)
            }
            Spacer()
        }
        .padding(8)
        .background(Color.customLightOrange)
        .cornerRadius(4)
    }
}

struct BarChart: View {
    let bars = [
        BarCharItem(value: "$100", name: "product 1", percent: 0.5),
        BarCharItem(value: "$250", name: "product 2", percent: 0.9),
        BarCharItem(value: "$200", name: "product 3", percent: 0.8),
        BarCharItem(value: "$120", name: "product 4", percent: 0.1),
        BarCharItem(value: "$120", name: "product 5", percent: 0.2),
        BarCharItem(value: "$120", name: "product 6", percent: 0.23),
        BarCharItem(value: "$120", name: "product 7", percent: 0.98)
    ]
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 8) {
                ForEach(bars) { bar in
                    Bar(model: bar).frame(width: geo.size.width * bar.percent)
                }
                
            }
        }
        .scaledToFit()
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart()
    }
}
