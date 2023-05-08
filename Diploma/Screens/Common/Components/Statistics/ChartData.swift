import Foundation
import SwiftUI

struct ChartDataWrapper: Identifiable {
    var id = UUID()
    var name: String
    var value: Double
    var percent: CGFloat
    var color: Color
    var offset: Double
}

struct ChartData {
    var name: String
    var value: Double
}

class ChartDataContainer: ObservableObject {
    static let empty = ChartDataContainer([])
    
    let chartData: [ChartDataWrapper]
    
    init(_ data: [ChartData], maxSegments: Int = 4) {
        let segmentsNumber = max(1, maxSegments)
        chartData = ChartDataContainer.convertData(data, maxSegments: segmentsNumber)
    }
    
    private static func convertData(_ data: [ChartData], maxSegments: Int) -> [ChartDataWrapper] {
        var percentOffset: CGFloat = 0
        
        let totalValue = data.map { $0.value }.reduce(0, +)
        
        let convertedData = data.sorted { $0.value > $1.value }
            .map { originalData in
                let percentOfTotal = originalData.value / totalValue
                percentOffset += percentOfTotal
                return ChartDataWrapper(name: originalData.name,
                                        value: originalData.value,
                                        percent: percentOfTotal,
                                        color: .random,
                                        offset: percentOffset)
            }
        
        guard convertedData.count > maxSegments else { return convertedData }
        
        let biggestValues = convertedData[0..<maxSegments-1]
        let smallestValues = convertedData[maxSegments-1..<convertedData.count]
        let otherValue = smallestValues.map { $0.value }.reduce(0, +)
        let otherPercent = smallestValues.map { $0.percent }.reduce(0, +)
        
        let otherData = ChartDataWrapper(name: "Другое",
                                         value: otherValue,
                                         percent: otherPercent,
                                         color: .customDarkGray,
                                         offset: smallestValues.last?.offset ?? 0)
        
        return biggestValues + [otherData]
    }
}
