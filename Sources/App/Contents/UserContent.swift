import Vapor

struct UserContent: Content, Validatable {
    var name: String
    var email: String
    var password: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty, required: true)
        validations.add("email", as: String.self, is: !.empty, required: true)
        validations.add("password", as: String.self, is: !.empty, required: true)
    }
}
