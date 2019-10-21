// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Extensions",
    platforms: [.iOS(.v10)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Extensions",
            targets: [
                "Extensions",
                "Extensions-Stdlib",
                "Extensions-UIKit",
                "Extensions-Foundation",
                "Extensions-QuartzCore"
            ]
        ),
        .library(
            name: "Extensions-Stdlib",
            targets: ["Extensions-Stdlib"]
        ),
        .library(
            name: "Extensions-UIKit",
            targets: ["Extensions-UIKit"]
        ),
        .library(
            name: "Extensions-Foundation",
            targets: ["Extensions-Foundation"]
        ),
        .library(
            name: "Extensions-QuartzCore",
            targets: ["Extensions-QuartzCore"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.Extensions-Stdlib
        .target(
            name: "Extensions",
            dependencies: [
                "Extensions-Stdlib",
                "Extensions-UIKit",
                "Extensions-Foundation"
            ],
            path: "Sources",
            sources: ["Extensions"]
        ),
        .target(
            name: "Extensions-Stdlib",
            path: "Sources",
            sources: ["Stdlib"]
        ),
        .target(
            name: "Extensions-UIKit",
            path: "Sources",
            sources: ["UIKit", "CoreGraphics"]
        ),
        .target(
            name: "Extensions-Foundation",
            path: "Sources",
            sources: ["Foundation", "Dispatch"]
        ),
        .target(
            name: "Extensions-QuartzCore",
            dependencies: [
                "Extensions-Foundation"
            ],
            path: "Sources",
            sources: ["QuartzCore"]
        ),
        .testTarget(
            name: "ExtensionsTests",
            dependencies: ["Extensions"]),
    ]
    , swiftLanguageVersions: [.v5]
)
