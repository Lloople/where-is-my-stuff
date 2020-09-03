import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "created_at")
    var createdAt: Date
    
    @Children(for: \.$user)
    var things: [Thing]

    init() { }

    init(id: UUID? = nil, name: String, email: String, password: String) throws {
        self.id = id
        self.name = name
        self.email = email
        self.password = try Bcrypt.hash(password)
        self.createdAt = Date()
    }
}
