import Vapor
import Fluent

struct ApiUserUpdateAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
        let input = try req.content.decode(UserUpdateContent.self)
        
        try UserUpdateContent.validate(content: req)
        
        return User.find(try req.inputUUID("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.name = input.name
                user.email = input.email
                
                return user.update(on: req.db).flatMap {
                    return user.encodeResponse(status: .accepted, for: req)
                }
        }
    }
}
