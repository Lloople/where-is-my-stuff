@testable import App
import XCTVapor

final class ApiUserTest: TestCase {
    
    
    func test_can_get_users_index() throws {

        let user: User = try self.createUser()
                    
        try app.test(.GET, "api/users") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContains(res.body.string, user.id?.uuidString)
        }
    }
    
    func test_can_show_user() throws {
        
        let user: User = try self.createUser()
        
        try app.test(.GET, "api/users/\(user.id!)") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContains(res.body.string, try user.requireID().uuidString)
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
            XCTAssertEqual(res.status, .created)
            
            let user: User = try User.query(on: app.db).first()
                .unwrap(or: Abort(.notFound))
                .wait()
            
            XCTAssertEqual("Mark Watney", user.name)
            XCTAssertEqual("mwatney@nasa.gov", user.email)
            XCTAssertTrue(try Bcrypt.verify("spacepirate", created: user.password))
        }
    }
    
    func test_can_delete_user() throws {
        
        let user: User = try self.createUser()
        
        try app.test(.DELETE, "api/users/\(user.id!)") { res in
            XCTAssertEqual(res.status, .noContent)
            XCTAssertEqual(0, try User.query(on: app.db).count().wait())
        }
    }
    
    func test_can_update_user() throws {
        
        let user: User = try self.createUser(name: "Mork Wotney", email: "mwotney@gov.nasa")
        
        try app.test(.PUT, "api/users/\(user.id!)", beforeRequest: { req in
            try req.content.encode([
                "name": "Mark Watney",
                "email": "mwatney@nasa.gov",
                "password": "spacepirate"
            ])
        }) { res in
            XCTAssertEqual(res.status, .accepted)
            let content = try res.content.decode(UserUpdateContent.self)
            
            XCTAssertEqual(content.name, "Mark Watney")
            XCTAssertEqual(content.email, "mwatney@nasa.gov")
        }
    }
}
