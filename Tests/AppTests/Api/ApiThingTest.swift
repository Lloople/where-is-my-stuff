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
    
    func test_can_create_a_thing() throws {
        
        let user: User = try User(name: "Mark Watney", email: "mwatney@nasa.gov", password: "spacepirate")
        
        try user.create(on: app.db).wait()
        
        try app.test(.POST, "api/users/\(user.requireID())/things", beforeRequest: { req in
            try req.content.encode([
                "name": "Rover",
                "description": "Since I'm driving this without authorization, I'm a space pirate!"
            ])
        }) { res in
            XCTAssertEqual(res.status, .ok)

            let thing: Thing = try Thing.query(on: app.db).first()
                .unwrap(or: Abort(.notFound))
                .wait()
            
            XCTAssertEqual("Rover", thing.name)
            XCTAssertEqual(try user.requireID(), thing.$user.id)
        }
    }
}
