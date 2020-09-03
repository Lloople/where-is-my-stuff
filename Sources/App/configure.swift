import Fluent
import FluentMySQLDriver
import Vapor

public func configure(_ app: Application) throws {
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    prepareDatabase(app)
    
    try routes(app)
}


func prepareDatabase(_ app: Application) {
    app.databases.use(.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "vapor",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor",
        database: Environment.get("DATABASE_NAME") ?? "where_is_my_stuff",
        tlsConfiguration: .forClient(certificateVerification: .none)
        ), as: .mysql)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateThing())
}
