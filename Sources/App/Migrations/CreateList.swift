import Fluent

struct CreateList: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lists")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("name", .string, .required)
            .field("color", .string)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lists").delete()
    }
}
