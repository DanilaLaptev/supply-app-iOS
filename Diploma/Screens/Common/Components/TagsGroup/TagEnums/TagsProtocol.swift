import Foundation
import SwiftUI

protocol TagsGroupProtocol: CaseIterable, Equatable {
    var icon: Image { get }
    var name: String { get }
}
