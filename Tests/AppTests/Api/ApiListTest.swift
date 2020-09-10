@testable import App
import XCTVapor

final class ApiListTest: TestCase {
    
    
    func test_can_get_list_index() throws {
        
        let user: User = try self.createUser()
        
        let list: List = try List(name: "Rover")
        
        try user.$lists.create(list, on: app.db).wait()
        
        try app.test(.GET, "api/users/\(user.requireID())/lists") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContains(res.body.string, list.id?.uuidString)
        }
    }
    
}
