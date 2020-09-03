@testable import App
import XCTVapor

final class ApiUserTest: TestCase {
    
    
    func test_can_get_users_index() throws {

        let user: User = try User(name: "Mark Watney", email: "mwatney@nasa.gov", password: "spacepirate")
            
        try user.create(on: app.db).wait()
        
        try app.test(.GET, "api/users") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContains(res.body.string, user.id?.uuidString)
        }
    }
}
