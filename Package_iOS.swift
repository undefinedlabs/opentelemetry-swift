// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

// The purpose of this file is to disable executable targets and products that fail to compile in iOS.
// SPM still doesnt support disabling targets per platform.
// This file will be used as replacement for original Package.swift when built for testing using undefinedlabs/scope-for-ios-action,
// the replacement is performed automatically by the action

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
        //.executable(name: "simpleExporter", targets: ["SimpleExporter"]),
        //.executable(name: "loggingTracer", targets: ["LoggingTracer"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(  name: "OpenTelemetryApi", dependencies: []),
        .target(  name: "OpenTelemetrySdk", dependencies: ["OpenTelemetryApi"]),
        //.target(  name: "LoggingTracer", dependencies: ["OpenTelemetryApi"], path: "Examples/Logging Tracer"),
        //.target(  name: "SimpleExporter", dependencies: ["OpenTelemetrySdk"], path: "Examples/Simple Exporter"),
        .testTarget( name: "OpenTelemetryApiTests", dependencies: ["OpenTelemetryApi"], path: "Tests/OpenTelemetryApiTests"),
        .testTarget( name: "OpenTelemetrySdkTests", dependencies: ["OpenTelemetryApi", "OpenTelemetrySdk"], path: "Tests/OpenTelemetrySdkTests"),
    ]
)

