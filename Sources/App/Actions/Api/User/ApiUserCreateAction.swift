import Vapor
import Fluent

struct ApiUserCreateAction {
    init() { }
    
    func invoke(req: Request) throws -> EventLoopFuture<Response> {
        
        try CreateUserContent.validate(content: req)
        
        let input = try req.content.decode(CreateUserContent.self)
        
        let user = try User(
            name: input.name,
            email: input.email,
            password: input.password
        )
        
        return user.create(on: req.db).map { Response(status: .created) }
    }
}
