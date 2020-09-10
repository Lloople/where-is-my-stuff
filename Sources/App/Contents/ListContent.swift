import Vapor

struct ListContent: Content, Validatable {
    var name: String
    var color: String?
    
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty, required: true)
        validations.add("color", as: String.self, required: false)
    }
}
