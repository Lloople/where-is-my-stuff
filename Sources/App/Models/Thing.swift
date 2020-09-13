import Fluent
import Vapor

final class Thing: Model, Content {
        
    static let schema = "things"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @OptionalParent(key: "list_id")
    var list: List?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String?
    
    @Field(key: "status")
    var status: String?
    
    @Field(key: "photo")
    var photo: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(name: String, description: String? = nil, status: String? = nil, photo: String? = nil) throws {
        self.name = name
        self.description = description
        self.status = status
        self.photo = photo
    }
}
