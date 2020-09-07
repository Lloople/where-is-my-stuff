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
    
    func test_can_create_a_user() throws {
        
        try app.test(.POST, "api/users", beforeRequest: { req in
            try req.content.encode([
                "name": "Mark Watney",
                "email": "mwatney@nasa.gov",
                "password": "spacepirate"
            ])
        }) { res in
            XCTAssertEqual(res.status, .ok)
            
            let user: User = try User.query(on: app.db).first()
                .unwrap(or: Abort(.notFound))
                .wait()
            
            XCTAssertEqual("Mark Watney", user.name)
            XCTAssertEqual("mwatney@nasa.gov", user.email)
            XCTAssertTrue(try Bcrypt.verify("spacepirate", created: user.password))
        }
    }
}
