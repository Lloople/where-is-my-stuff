import Fluent
import Vapor

final class Thing: Model, Content {
        
    static let schema = "things"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String?
    
    @Field(key: "status")
    var status: String?
    
    @Field(key: "photo")
    var photo: String?
    
    @Field(key: "created_at")
    var createdAt: Date
    
    init() { }
    
    init(name: String) throws {
        self.name = name
        self.createdAt = Date()
    }
    
}
