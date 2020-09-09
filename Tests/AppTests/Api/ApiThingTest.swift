@testable import App
import XCTVapor

final class ApiThingTest: TestCase {
    
    
    func test_can_get_things_index() throws {
        
        let user: User = try self.createUser()
        
        let thing: Thing = try Thing(name: "Rover")
        
        try user.$things.create(thing, on: app.db).wait()
        
        try app.test(.GET, "api/users/\(user.id!)/things") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContains(res.body.string, thing.id?.uuidString)
        }
    }
    
    func test_can_create_a_thing() throws {
        
        let user: User = try self.createUser()
        
        try app.test(.POST, "api/users/\(user.requireID())/things", beforeRequest: { req in
            try req.content.encode([
                "name": "Rover",
                "description": "Since I'm driving this without authorization, I'm a space pirate!"
            ])
        }) { res in
            XCTAssertEqual(res.status, .created)

            let thing: Thing = try Thing.query(on: app.db).first()
                .unwrap(or: Abort(.notFound))
                .wait()
            
            XCTAssertEqual("Rover", thing.name)
            XCTAssertEqual(try user.requireID(), thing.$user.id)
        }
    }
    
    func test_can_delete_user_thing() throws {
        
        let user: User = try self.createUser()
        
        let thing: Thing = try Thing(name: "Potato")
        
        try user.$things.create(thing, on: app.db).wait()
        
        try app.test(.DELETE, "api/users/\(user.id!)/things/\(thing.id!)") { res in
            XCTAssertEqual(res.status, .noContent)
            
            XCTAssertEqual(0, try Thing.query(on: app.db).count().wait())
        }
    }
    
    func test_can_show_user_thing() throws {
        
        let user: User = try self.createUser()
        
        let thing: Thing = try Thing(name: "Potato")
        
        try user.$things.create(thing, on: app.db).wait()
        
        try app.test(.GET, "api/users/\(user.id!)/things/\(thing.id!)") { res in
            XCTAssertEqual(res.status, .ok)
            let content = try res.content.decode(Thing.self)
            
            XCTAssertEqual(content.name, "Potato")
            XCTAssertEqual(content.$user.id, try user.requireID())
            XCTAssertEqual(try content.requireID(), try thing.requireID())
        }
    }
    
    func test_can_update_user_thing() throws {
        
        let user: User = try self.createUser()
        
        let thing: Thing = try Thing(name: "Potata")
        
        try user.$things.create(thing, on: app.db).wait()
        
        try app.test(.PUT, "api/users/\(user.id!)/things/\(thing.id!)", beforeRequest: { req in
            try req.content.encode([
                "name": "Potato"
            ])
        }) { res in
            XCTAssertEqual(res.status, .accepted)
            
            let content = try res.content.decode(Thing.self)
            
            XCTAssertEqual(content.name, "Potato")
        }
    }
    
}
