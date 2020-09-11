import Vapor
import Fluent

struct ApiListUpdateAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
        let input = try req.content.decode(ListContent.self)

        try ListContent.validate(content: req)
        
        return try List.query(on: req.db)
            .filter(\.$id == req.inputUUID("listId"))
            .filter(\.$user.$id == req.inputUUID("userId"))
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { list in
                
                list.name = input.name
                list.color = input.color
                
                return list.update(on: req.db).flatMap {
                    return list.encodeResponse(status: .accepted, for: req)
                }
        }
    }
}
