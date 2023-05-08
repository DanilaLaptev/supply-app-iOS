import Foundation

struct SupplyDto: Codable {
    var fromBranch: Int?
    var toBranch: Int?
    var deliveryTime: String? // 2007-12-03T10:15:30
    var groupId: Int?
    var items: [StorageItemDto]?
    var statuses: [SupplyStatusDto]?
    var created: String? // 2007-12-03T10:15:30
}
