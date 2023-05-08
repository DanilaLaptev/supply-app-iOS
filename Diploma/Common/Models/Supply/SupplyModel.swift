import Foundation

struct SupplyStatusHistory {
    let status: SupplyStatus
    let created: Date?
    
    static func from(_ dto: SupplyStatusDto) -> SupplyStatusHistory {
        SupplyStatusHistory(
            status: dto.status ?? .pending,
            created: dto.time?.toDate()
        )
    }
}

struct SupplyModel: Identifiable {
    var id = UUID().hashValue
    var publicId: Int
    var products: [StorageItemModel]
    var statusHistory: [SupplyStatusHistory]
    var deliveryTime: Date?
    var created: Date?
    var fromBranchId: Int?
    var toBranchId: Int?

    var totalPrice: Double {
        products.map { $0.price * Double($0.quantity) }.reduce(0, +)
    }
    
    var lastTimeUpdated: Date? {
        self.statusHistory.first?.created
    }
    
    static func from(_ dto: SupplyDto) -> SupplyModel {
        SupplyModel(
            id: dto.groupId ?? -1,
            publicId: dto.groupId ?? -1,
            products: dto.items?.map { StorageItemModel.from($0) } ?? [],
            statusHistory: dto.statuses?.map { SupplyStatusHistory.from($0) } ?? [],
            deliveryTime:  dto.deliveryTime?.toDate(),
            created: dto.created?.toDate(),
            fromBranchId: dto.fromBranch,
            toBranchId: dto.toBranch
        )
    }
}

extension SupplyModel {
    static var empty: SupplyModel { SupplyModel(id: UUID().hashValue,
                                                publicId: 0,
                                                products: [],
                                                statusHistory: [],
                                                deliveryTime: Date(),
                                                created: Date()
    ) }
}
