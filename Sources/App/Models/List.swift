import Fluent
import Vapor

final class List: Content, Model {
 
    static let schema = "lists"
    
    @ID(key: .id)
    var id: UUID?
    
    @Children(for: \.$list)
    var things: [Thing]
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "color")
    var color: String?
    
    @Parent(key: "user_id")
    var user: User
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(name: String, color: String? = nil) {
        self.name = name
        self.color = color
    }
}
