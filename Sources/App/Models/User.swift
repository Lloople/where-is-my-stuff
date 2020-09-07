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
    
    @Children(for: \.$user)
    var things: [Thing]
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, name: String, email: String, password: String) throws {
        self.id = id
        self.name = name
        self.email = email
        self.password = try Bcrypt.hash(password)
    }
}
