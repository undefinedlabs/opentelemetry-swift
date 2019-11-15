// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "opentelemetry-swift",
    platforms: [.macOS(.v10_12),
                .iOS(.v10),
                .tvOS(.v10),
                .watchOS(.v3)],
    products: [
        .library( name: "Api", targets: ["Api"]),
        .library( name: "Sdk", targets: ["Sdk"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(  name: "Api", dependencies: []),
        .target(  name: "Sdk", dependencies: ["Api"]),

        .testTarget( name: "ApiTests", dependencies: ["Api"], path: "Tests/ApiTests"),
        .testTarget( name: "SdkTests", dependencies: ["Api", "Sdk"], path: "Tests/SdkTests"),
    ]
)