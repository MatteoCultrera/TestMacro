// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "TestScript",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/PrometheusBytes/swifty-scripty", .upToNextMajor(from: "0.3.0")),
    ],
    targets: [
        .executableTarget(
            name: "TestScript",
            dependencies: [
                .product(name: "SwiftyScripty", package: "swifty-scripty")
            ],
            path: "Sources/TestScript",
            swiftSettings: [.unsafeFlags(["-enable-bare-slash-regex"])]
        ),
    ]
)
