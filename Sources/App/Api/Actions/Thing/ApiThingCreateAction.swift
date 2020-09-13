import Vapor
import Fluent

struct ApiThingCreateAction {
    
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
      
        try ThingContent.validate(content: req)
        
        let input = try req.content.decode(ThingContent.self)

        let thing = try Thing(
            name: input.name,
            description: input.description,
            status: input.status
        )

        if (input.listId != nil) {
            thing.$list.id = input.listId!
        }
        

        return User.find(try req.inputUUID("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$things.create(thing, on: req.db)
            }
            .map { Response(status: .created) }
    }
}
