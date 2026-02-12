// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VinReadability",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "VinReadability",
            targets: ["VinReadability"]
        ),
    ],
	dependencies: [
		.package(url: "https://github.com/mattmassicotte/SwiftyJSCore.git", branch: "main"),
	],
    targets: [
        .target(
            name: "VinReadability",
            dependencies: ["SwiftyJSCore"],
            resources: [.copy("Resources")]
        ),
        .testTarget(
            name: "VinReadabilityTests",
            dependencies: ["VinReadability"]
        ),
    ]
)
