import Vapor
import Fluent

struct ApiUserCreateAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
        
        try UserContent.validate(content: req)
        
        let input = try req.content.decode(UserContent.self)
        
        let user = try User(
            name: input.name,
            email: input.email,
            password: input.password
        )
        
        return user.create(on: req.db).map { Response(status: .created) }
    }
}
