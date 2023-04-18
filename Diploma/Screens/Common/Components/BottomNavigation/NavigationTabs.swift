import Foundation

class NavigationTabs {
    public static let customerTabs = [
        CustomTab(icon: .customHome, name: "Главная", screenTag: WorkerMainView.tag),
        CustomTab(icon: .customBox, name: "Поставки", screenTag: SuppliersListView.tag),
        CustomTab(icon: .customRoute, name: "Заказы", screenTag: WorkerSupplyListScreen.tag),
        CustomTab(icon: .customChart, name: "Учёт", screenTag: StatisticsScreen.tag),
        CustomTab(icon: .customUser, name: "Профиль", screenTag: ProfileScreen.tag)
    ]

    public static let supplierTabs = [
        CustomTab(icon: .customHome, name: "Главная", screenTag: SupplierMainScreen.tag),
        CustomTab(icon: .customBox, name: "Поставки", screenTag: ClientsListView.tag),
        CustomTab(icon: .customRoute, name: "Заказы", screenTag: SupplierOrdersView.tag),
        CustomTab(icon: .customChart, name: "Учёт", screenTag: SupplierStatisticsView.tag),
        CustomTab(icon: .customUser, name: "Профиль", screenTag: ProfileScreen.tag)
    ]
}
