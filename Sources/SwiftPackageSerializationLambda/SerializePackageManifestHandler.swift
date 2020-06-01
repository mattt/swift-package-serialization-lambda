import Foundation
import AWSLambdaRuntime
import NIO

struct SerializePackageManifestHandler: EventLoopLambdaHandler {
    typealias In = String
    typealias Out = String

    func handle(context: Lambda.Context, payload: In) -> EventLoopFuture<Out> {
        do {
            let manifest = try Manifest(parsing: payload)
            let json = try dumpPackage(manifest)

            return context.eventLoop.makeSucceededFuture(json)
        } catch {
            return context.eventLoop.makeFailedFuture(error)
        }
    }
}
