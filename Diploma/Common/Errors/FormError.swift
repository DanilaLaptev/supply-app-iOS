import Foundation

enum FormError: Error, LocalizedError {
    case requiredField(source: String)
    case wrongFormat(source: String)
    case minimumCharactersNumber(source: String, _ minimum: Int)
    case maximumCharactersNumber(source: String, _ maximum: Int)
    case unknownError(source: String)
    case customError(source: String, description: String)

    public var errorDescription: String? {
        switch self {
            
        case .requiredField(let source):
            return "\(source): Обязательное поле"
        case .wrongFormat(let source):
            return "\(source): Неверный формат"
        case .minimumCharactersNumber(let source, let min):
            return "\(source): Минимум символов \(min)"
        case .maximumCharactersNumber(let source, let max):
            return "\(source): Максимум символов \(max)"
        case .unknownError(let source):
            return "\(source): Неизвестная ошибка"
        case .customError(source: let source, description: let description):
            return "\(source): \(description)"
        }
    }
}
