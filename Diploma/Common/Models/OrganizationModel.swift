import Foundation

struct OrganizationModel: Identifiable {
    let id = UUID().hashValue
    let title: String
    let organiztionImageUrl: String
    let address: Address
    
    let storageItems: [StorageItemModel]
    
    static var empty = OrganizationModel(
        title: "none",
        organiztionImageUrl: "none",
        address: Address(addressName: "none", longitude: 0, latitude: 0),
        storageItems: []
    )
    
    static var test = OrganizationModel(
        title: "Тестовая организация",
        organiztionImageUrl: "https://www.profocustechnology.com/wp-content/uploads/2015/10/search-and-find-bugs-debugging-102917333.jpg",
        address: Address(addressName: "Тестовая локация", longitude: 0, latitude: 0),
        storageItems: [
            StorageItemModel(product: ProductModel(
                name: "Coca cola 1.0",
                isApproved: true,
                type: .drinks
            ),
                             imageUrl: "https://mundolatas.com/wp-content/uploads/coca-cola-1080x675.jpg",
                             price: 42,
                             quantity: 5,
                             description: "Газированный напиток"),
            StorageItemModel(product: ProductModel(
                name: "Fanta 0.5",
                isApproved: true,
                type: .drinks
            ),
                             imageUrl: "https://i.ytimg.com/vi/ZZWOT7HLA48/maxresdefault.jpg",
                             price: 45,
                             quantity: 32,
                             description: "Газированный напиток"),
            StorageItemModel(product: ProductModel(
                name: "Булочка с маком",
                isApproved: true,
                type: .bakery
            ),
                             imageUrl: "https://british-bakery.ru/upload/iblock/0ad/0add711ccc5a2523929b5c1e26f6a49a.jpg",
                             price: 25,
                             quantity: 20,
                             description: "Выпечка"),
            StorageItemModel(product: ProductModel(
                name: "Сдобная булочка",
                isApproved: true,
                type: .bakery
            ),
                             imageUrl: "https://static.1000.menu/img/content-v2/8a/8c/43270/bulochki-s-saxarom-iz-sdobnogo-drojjevogo-testa_1582100715_16_max.jpg",
                             price: 25,
                             quantity: 20,
                             description: "Выпечка"),
            .empty,
            .empty,
            .empty,
            .empty
        ]
    )
}
