import Vapor
import Fluent

struct ApiUserShowAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<User> {
        
        return User.find(try req.inputUUID("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
}
