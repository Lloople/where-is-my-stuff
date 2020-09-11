import Vapor

protocol UserContentProtocol: Content, Validatable {
    var name: String { get set }
    var email: String { get set }
    var password: String? { get set }
    static var passwordRequired: Bool { get }
}

extension UserContentProtocol {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty, required: true)
        validations.add("email", as: String.self, is: !.empty, required: true)
        validations.add("password", as: String.self, is: !.empty, required: self.passwordRequired)
    }
}

struct UserCreateContent: UserContentProtocol {
    var name, email: String
    var password: String?
    static var passwordRequired: Bool { true }
}

struct UserUpdateContent: UserContentProtocol {
    var name, email: String
    var password: String?
    static var passwordRequired: Bool { false }
}
