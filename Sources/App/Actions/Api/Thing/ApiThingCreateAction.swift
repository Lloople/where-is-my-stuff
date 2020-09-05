import Vapor
import Fluent

struct ApiThingCreateAction {
    
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
      
        try CreateThingRequest.validate(content: req)
        
        let thing = try req.content.decode(Thing.self)
        
        return User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$things
                    .create(thing, on: req.db)
                    .map{ Response( status: .ok) }
        }
    }
}
