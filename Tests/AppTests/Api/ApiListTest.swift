@testable import App
import XCTVapor

final class ApiListTest: TestCase {
    
    
    func test_can_get_list_index() throws {
        
        let user: User = try self.createUser()
        
        let list: List = List(name: "Rover")
        
        try user.$lists.create(list, on: app.db).wait()
        
        try app.test(.GET, "api/users/\(user.requireID())/lists") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContains(res.body.string, list.id?.uuidString)
        }
    }
    
    func test_can_create_a_list() throws {
        
        let user: User = try self.createUser()
        
        try app.test(.POST, "api/users/\(user.requireID())/lists", beforeRequest: { req in
            try req.content.encode([
                "name": "Vehicles",
                "color": "#FFF"
            ])
        }) { res in
            XCTAssertEqual(res.status, .created)
            
            let list: List = try List.query(on: app.db).first()
                .unwrap(or: Abort(.notFound))
                .wait()
            
            XCTAssertEqual(list.name, "Vehicles")
            XCTAssertEqual(try user.requireID(), list.$user.id)
        }
    }
    
}
