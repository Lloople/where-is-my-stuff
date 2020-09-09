import Vapor
import Fluent

struct ApiThingShowAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Thing> {

        return try Thing.query(on: req.db)
            .filter(\.$id == req.inputUUID("thingId"))
            .filter(\.$user.$id == req.inputUUID("userId"))
            .first()
            .unwrap(or: Abort(.notFound))
    }
}
