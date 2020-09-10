import Vapor
import Fluent

struct ApiListCreateAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
        
        try ListContent.validate(content: req)
        
        let input = try req.content.decode(ListContent.self)
        
        let list = List(
            name: input.name,
            color: input.color
        )
        
        return User.find(try req.inputUUID("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$lists.create(list, on: req.db)
        }
        .map { Response(status: .created) }
    }
}
