import Foundation

class NavigationTabs {
    public static let customerTabs = [
        CustomTab(icon: .customHome, name: "Главная", screenTag: MainScreen.tag),
        CustomTab(icon: .customBox, name: "Поставки", screenTag: SuppliersListScreen.tag),
        CustomTab(icon: .customRoute, name: "Заказы", screenTag: OrdersListScreen.tag),
        CustomTab(icon: .customChart, name: "Учёт", screenTag: StatisticsScreen.tag),
        CustomTab(icon: .customUser, name: "Профиль", screenTag: ProfileScreen.tag)
    ]

    public static let supplierTabs = [
        CustomTab(icon: .customHome, name: "Главная", screenTag: SupplierMainScreen.tag),
        CustomTab(icon: .customBox, name: "Поставки", screenTag: SupplierClientsScreen.tag),
        CustomTab(icon: .customRoute, name: "Заказы", screenTag: SupplierOrdersView.tag),
        CustomTab(icon: .customChart, name: "Учёт", screenTag: SupplierStatisticsView.tag),
        CustomTab(icon: .customUser, name: "Профиль", screenTag: ProfileScreen.tag)
    ]
}
