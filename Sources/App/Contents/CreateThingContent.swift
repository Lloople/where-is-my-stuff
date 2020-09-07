import Vapor

struct CreateThingContent: Content, Validatable {
    var name: String
    var description: String?
    var status: String?
    var photo: String?
    
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty, required: true)
        validations.add("description", as: String.self, required: false)
        validations.add("status", as: String.self, required: false)
        validations.add("photo", as: String.self, required: false)
    }
}
