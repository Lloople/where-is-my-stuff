import Vapor
import Fluent

struct ApiListShowAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<List> {

        return try List.query(on: req.db)
            .filter(\.$id == req.inputUUID("listId"))
            .filter(\.$user.$id == req.inputUUID("userId"))
            .first()
            .unwrap(or: Abort(.notFound))
    }
}
