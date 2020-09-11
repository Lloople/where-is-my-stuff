import Vapor
import Fluent

struct ApiUserIndexAction {
    
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }
}
