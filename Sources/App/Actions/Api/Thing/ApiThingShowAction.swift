import Vapor
import Fluent

struct ApiThingShowAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Thing> {
        
        let userId: UUID = try req.inputUUID("userId")
        let thingId: UUID = try req.inputUUID("thingId")
        
        return Thing.query(on: req.db)
            .filter(\.$id == thingId)
            .filter(\.$user.$id == userId)
            .first()
            .unwrap(or: Abort(.notFound))
    }
}
