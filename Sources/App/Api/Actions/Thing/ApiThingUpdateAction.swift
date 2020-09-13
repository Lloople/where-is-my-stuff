import Vapor
import Fluent

struct ApiThingUpdateAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
        let input = try req.content.decode(ThingContent.self)

        try ThingContent.validate(content: req)
        
        return try Thing.query(on: req.db)
            .filter(\.$id == req.inputUUID("thingId"))
            .filter(\.$user.$id == req.inputUUID("userId"))
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { thing in
                
                thing.name = input.name
                thing.description = input.description
                thing.photo = input.photo
                thing.status = input.status
                thing.$list.id = input.listId
                
                return thing.update(on: req.db).flatMap {
                    return thing.encodeResponse(status: .accepted, for: req)
                }
        }
    }
}
