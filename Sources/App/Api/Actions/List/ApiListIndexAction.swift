import Vapor
import Fluent

struct ApiListIndexAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<[List]> {
        return List.query(on: req.db).all()
    }
}
