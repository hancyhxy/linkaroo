// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ABDesignSystem",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ABDesignSystem",
            targets: ["ABDesignSystem"]
        ),
    ],
    targets: [
        .target(
            name: "ABDesignSystem",
            path: "Sources"
        ),
    ]
)
