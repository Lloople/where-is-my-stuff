import Vapor
import Fluent

struct ApiThingDeleteAction {
    
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
        
        return User.find(try req.inputUUID("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { user in
                try user.$things.query(on: req.db)
                    .filter(\.$id == req.inputUUID("thingId"))
                    .delete()
                
        }
        .map { Response( status: .noContent) }
    }
}
