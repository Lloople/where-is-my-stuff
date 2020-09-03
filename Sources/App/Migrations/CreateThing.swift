import Fluent

struct CreateThing: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("things")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("name", .string, .required)
            .field("description", .string)
            .field("status", .string)
            .field("created_at", .datetime, .required)
            .field("photo", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("things").delete()
    }
}
