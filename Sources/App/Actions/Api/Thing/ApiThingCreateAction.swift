import Vapor
import Fluent

struct ApiThingCreateAction {
    
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
      
        try CreateThingContent.validate(content: req)
        
        let input = try req.content.decode(CreateThingContent.self)

        let thing = try Thing(
            name: input.name,
            description: input.description,
            status: input.status
        )
        
        return User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$things.create(thing, on: req.db)
            }
            .map { Response(status: .created) }
    }
}
