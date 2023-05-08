import Foundation

struct SupplyFilterDto: Codable {
    var startDate: String?
    var endDate: String?
    var outgoingSupply: Bool
    var incomingSupply: Bool
    var branchId: Int?
}
