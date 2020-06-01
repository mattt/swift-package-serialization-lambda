import Foundation

import AWSLambdaRuntime
import NIO

import TSCBasic
import TSCUtility
import PackageModel
import PackageLoading
import PackageDescription

fileprivate let swiftCompiler: AbsolutePath = {
    let string: String
    #if os(macOS)
    string = try! Process.checkNonZeroExit(args: "xcrun", "--sdk", "macosx", "-f", "swiftc").spm_chomp()
    #else
    string = try! Process.checkNonZeroExit(args: "which", "swiftc").spm_chomp()
    #endif
    return AbsolutePath(string)
}()

fileprivate func loadManifest(_ contents: String) throws -> Manifest {
    let stream = BufferedOutputByteStream()
    stream <<< contents

    let provider = try! UserManifestResources(swiftCompiler: swiftCompiler)
    let manifestLoader = ManifestLoader(manifestResources: provider)

    let fs = InMemoryFileSystem()

    let manifestPath = AbsolutePath.root.appending(component: "Package.swift")
    try fs.writeFileContents(manifestPath, bytes: stream.bytes)

    let manifest = try manifestLoader.load(
        package: AbsolutePath.root,
        baseURL: "/Example",
        toolsVersion: .currentToolsVersion,
        packageKind: .root,
        fileSystem: fs)
    return manifest
}

struct SerializePackageManifestHandler: EventLoopLambdaHandler {
    typealias In = String
    typealias Out = String

    func handle(context: Lambda.Context, payload: In) -> EventLoopFuture<Out> {
        do {
            let manifest = try loadManifest(payload)
            let encoder = JSONEncoder()
            let data = try encoder.encode(manifest)
            let json = String(data: data, encoding: .utf8)!
            return context.eventLoop.makeSucceededFuture(json)
        } catch {
            return context.eventLoop.makeFailedFuture(error)
        }
    }
}
