// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "QMacros",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(
            name: "QMacros",
            targets: ["QMacros"]
        ),
        .executable(
            name: "QMacrosClient",
            targets: ["QMacrosClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.1"),
    ],
    targets: [
        .target(name: "QMacrosModels"),
        .macro(
            name: "QMacrosImpl",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                "QMacrosModels"
            ]
        ),
        .target(name: "QMacros", dependencies: ["QMacrosImpl", "QMacrosModels"]),
        .executableTarget(name: "QMacrosClient", dependencies: ["QMacros"]),
        .testTarget(
            name: "QMacrosTests",
            dependencies: [
                "QMacrosImpl",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
