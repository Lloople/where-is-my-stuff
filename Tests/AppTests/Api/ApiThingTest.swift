@testable import App
import XCTVapor

final class ApiThingTest: TestCase {
    
    
    func test_can_get_things_index() throws {
        
        let user: User = try User(name: "Mark Watney", email: "mwatney@nasa.gov", password: "spacepirate")
        
        try user.create(on: app.db).wait()
        
        let thing = try Thing(name: "Rover")
        
        try user.$things.create(thing, on: app.db).wait()
        
        try app.test(.GET, "api/users/\(user.id!)/things") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContains(res.body.string, thing.id?.uuidString)
        }
    }
}
