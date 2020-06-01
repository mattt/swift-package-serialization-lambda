import Foundation

import TSCBasic
import TSCUtility

@_exported import PackageModel
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

extension Manifest {
    public convenience init(parsing contents: String) throws {
        let stream = BufferedOutputByteStream()
        stream <<< contents

        let provider = try UserManifestResources(swiftCompiler: swiftCompiler)
        let manifestLoader = ManifestLoader(manifestResources: provider)

        let fs = InMemoryFileSystem()

        let manifestPath = AbsolutePath.root.appending(component: "Package.swift")
        try fs.writeFileContents(manifestPath, bytes: stream.bytes)

        let manifest = try manifestLoader.load(
            package: AbsolutePath.root,
            baseURL: "/Example",
            toolsVersion: .currentToolsVersion,
            packageKind: .root,
            fileSystem: fs
        )

        self.init(
            name: manifest.name,
            platforms: manifest.platforms,
            path: AbsolutePath.root.appending(component: manifest.name),
            url: manifest.name,
            version: manifest.version,
            toolsVersion: manifest.toolsVersion,
            packageKind: manifest.packageKind,
            pkgConfig: manifest.pkgConfig,
            providers: manifest.providers,
            cLanguageStandard: manifest.cLanguageStandard,
            cxxLanguageStandard: manifest.cxxLanguageStandard,
            swiftLanguageVersions: manifest.swiftLanguageVersions,
            dependencies: manifest.dependencies,
            products: manifest.products,
            targets: manifest.targets
        )
    }
}

public func dumpPackage(_ manifest: Manifest) throws -> String {
    let encoder = JSONEncoder()
    let encoded = try encoder.encode(manifest)

    var object = try JSONSerialization.jsonObject(with: encoded, options: []) as! [String: Any]
    _ = object.removeValue(forKey: "path")
    _ = object.removeValue(forKey: "url")
    _ = object.removeValue(forKey: "version")

    let data = try JSONSerialization.data(withJSONObject: object, options: [])
    return String(data: data, encoding: .utf8)!
}
