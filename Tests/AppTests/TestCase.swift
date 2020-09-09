@testable import App
import XCTVapor

class TestCase: XCTestCase {
    
    let app = Application(.testing)
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        
        setenv("DATABASE_NAME", "testingdatabase", 1)
        
        try configure(self.app)
        
        try self.app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        
        try self.app.autoRevert().wait()
        
        self.app.shutdown()
        
        try super.tearDownWithError()
    }
    
    internal func createUser(name: String? = nil, email: String? = nil, password: String? = nil) throws -> User {
        let user: User = try User(
            name: name ?? "Mark Watney",
            email: email ?? "mwatney@nasa.gov",
            password: password ?? "spacepirate"
        )
        
        try user.create(on: app.db).wait()
        
        return user
    }
}
