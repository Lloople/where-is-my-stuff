import Vapor
import Fluent

struct ApiThingIndexAction {
    
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<[Thing]> {
        
        return User.find(try req.inputUUID("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                return user.$things.query(on: req.db).all()
        }
    }
}
