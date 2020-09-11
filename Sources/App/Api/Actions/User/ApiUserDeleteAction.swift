import Vapor
import Fluent

struct ApiUserDeleteAction {
    
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
               
        return User.find(try req.inputUUID("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.delete(on: req.db)
                
        }
        .map { Response( status: .noContent) }
    }
}
