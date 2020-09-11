import Vapor
import Fluent

struct ApiListDeleteAction {

    init() { }

    func invoke(req: Request) throws -> EventLoopFuture<Response> {

        return try List.query(on: req.db)
            .filter(\.$user.$id == req.inputUUID("userId"))
            .filter(\.$id == req.inputUUID("listId"))
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { list in
                list.delete(on: req.db)
        }
        .map{ Response(status: .noContent) }
    }
}
