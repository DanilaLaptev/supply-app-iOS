import Foundation

struct ContactPersonModel {
    var fullName: String?
    var email: String?
    var phone: String?
    
    static func from(_ dto: ContactPersonDto) -> ContactPersonModel {
        ContactPersonModel(
            fullName: dto.fullName,
            email: dto.email,
            phone: dto.phone
        )
    }
}
