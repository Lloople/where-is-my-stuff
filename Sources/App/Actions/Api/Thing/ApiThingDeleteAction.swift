import Vapor
import Fluent

struct ApiThingDeleteAction {
    
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
        
        return User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$things.query(on: req.db)
                    .filter(\.$id == UUID(req.parameters.get("thingId")!)!)
                    .delete()
                
        }
        .map { Response( status: .noContent) }
    }
}
