// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HNScraper",
    products: [
        .library(name: "HNScraper", targets: ["HNScraper"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HNScraper",
            dependencies: [], path: "Sources"),
        .testTarget(
            name: "HNScraperTests",
            dependencies: ["HNScraper"], path: "Tests"),
    ]
)
