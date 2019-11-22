// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "opentelemetry-swift",
    platforms: [.macOS(.v10_12),
                .iOS(.v10),
                .tvOS(.v10),
                .watchOS(.v3)],
    products: [
        .library( name: "OpenTelemetryApi", targets: ["OpenTelemetryApi"]),
        .library( name: "OpenTelemetrySdk", targets: ["OpenTelemetrySdk"]),
        .executable(name: "simpleExporter", targets: ["SimpleExporter"]),
        .executable(name: "loggingTracer", targets: ["LoggingTracer"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(  name: "OpenTelemetryApi", dependencies: []),
        .target(  name: "OpenTelemetrySdk", dependencies: ["OpenTelemetryApi"]),
        .target(  name: "LoggingTracer", dependencies: ["OpenTelemetryApi"], path: "Sources/Examples/Logging Tracer"),
        .target(  name: "SimpleExporter", dependencies: ["OpenTelemetrySdk"], path: "Sources/Examples/Simple Exporter"),
        .testTarget( name: "OpenTelemetryApiTests", dependencies: ["OpenTelemetryApi"], path: "Tests/OpenTelemetryApiTests"),
        .testTarget( name: "OpenTelemetrySdkTests", dependencies: ["OpenTelemetryApi", "OpenTelemetrySdk"], path: "Tests/OpenTelemetrySdkTests"),
    ]
)
