import Foundation
import SwiftUI

enum SupplyProcessingStatus: String, TagsGroupProtocol {
    case inWork = "В работе"
    case rejected = "Отклонено"
    case underConsideration = "На рассмотрении"
    
    var name: String { self.rawValue }
    
    var icon: Image {
        switch self {

        default:
            return .customBox
        }
    }
}
