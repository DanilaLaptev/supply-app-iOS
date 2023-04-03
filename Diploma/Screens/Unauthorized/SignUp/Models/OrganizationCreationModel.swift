import Foundation

class OrganizationCreationModel: ObservableObject {
    var name: String? = nil
    var role: UserRole? = nil
    var email: String? = nil
    var password: String? = nil
    var contactPerson: ContactPersonModel? = nil
    var address: Address? = nil
}
