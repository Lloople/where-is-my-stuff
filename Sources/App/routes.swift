import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    try routesApi(app)
}

func routesApi(_ app: Application) throws {
    app.get("api", "users", use: ApiUserIndexAction().invoke)
    
    app.get("api", "users", ":userId", "things", use: ApiThingIndexAction().invoke)
}
