import SwiftUI

struct BarCharItem: Identifiable {
    let id = UUID()
    let value: Double
    let name: String
}

struct BarChart: View {
//    @State private var chartdata = [
//        BarCharItem(value: 0.5, name: "test 12"),
//        BarCharItem(value: 0.15, name: "test 223"),
//        BarCharItem(value: 0.25, name: "test 3sdfsdfsdf"),
//        BarCharItem(value: 0.10, name: "test 4")
//    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            ForEach(chartdata) { item in
//                HStack(alignment: .center, spacing: 8) {
//                    VStack(alignment: .trailing, spacing: 8) {
//                        Text(item.name).font(.customStandard)
//                        Text("\(item.value)").font(.customHint)
//                    }
//                    .frame(maxWidth: , alignment: .trailing)
//                    
//                    HStack(alignment: .center, spacing: 4) {
//                        RoundedRectangle(cornerRadius: 2).foregroundColor(.customOrange).frame(width: .infinity, height: 16)
//                        RoundedRectangle(cornerRadius: 2).foregroundColor(.customGray).frame(width: item.value * 100, height: 16)
//                    }
//                }
//            }
        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart()
    }
}
