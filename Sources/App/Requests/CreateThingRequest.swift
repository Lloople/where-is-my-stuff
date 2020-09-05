import Vapor

struct CreateThingRequest: Content, Validatable {
    var name: String
    var description: String?
    var status: String?
    var photo: String?
    
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty, required: true)
    }
}
