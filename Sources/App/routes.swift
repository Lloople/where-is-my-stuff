import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    try routesApi(app)
}

func routesApi(_ app: Application) throws {
    let api = app.grouped("api")
                
    api.get("users", use: ApiUserIndexAction().invoke)
    api.post("users", use: ApiUserCreateAction().invoke)
    
    api.get("users", ":userId", "things", use: ApiThingIndexAction().invoke)
    api.post("users", ":userId", "things", use: ApiThingCreateAction().invoke)
}
