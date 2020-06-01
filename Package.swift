// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPackageSerializationLambda",
    platforms: [
        .macOS("10.13")
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .exact("0.1.0")),
        .package(name: "SwiftPM", url: "https://github.com/apple/swift-package-manager", .exact("0.6.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftPackageSerializationLambda",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "SwiftPM", package: "SwiftPM"),
                .product(name: "PackageDescription", package: "SwiftPM"),
            ]),
        .testTarget(
            name: "SwiftPackageSerializationLambdaTests",
            dependencies: ["SwiftPackageSerializationLambda"]),
    ]
)
