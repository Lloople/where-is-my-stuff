import Vapor

extension Request {
    func inputUUID(_ name: String) throws -> UUID {
        
        guard let uuid = self.parameters.get(name, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return uuid
    }
}
