import Vapor
import Fluent

struct ApiThingIndexAction {
    
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<[Thing]> {
        return User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                return user.$things.query(on: req.db).all()
        }
    }
}
