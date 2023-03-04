import Foundation

class NavigationTabs {
    public static let customerTabs = [
        CustomTab(icon: .customHome, name: "Главная"),
        CustomTab(icon: .customBox, name: "Поставки"),
        CustomTab(icon: .customRoute, name: "Заказы"),
        CustomTab(icon: .customChart, name: "Учёт"),
        CustomTab(icon: .customUser, name: "Профиль")
    ]
    
    public static let supplierTabs = [
        CustomTab(icon: .customHome, name: "Главная"),
        CustomTab(icon: .customRoute, name: "Заказы"),
        CustomTab(icon: .customChart, name: "Учёт"),
        CustomTab(icon: .customUser, name: "Профиль")
    ]
}
