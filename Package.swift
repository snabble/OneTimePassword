// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OneTimePassword",
    platforms: [
        .iOS("10.3.1"),
        .watchOS("3.2")
    ],
    products: [
        .library(
            name: "OneTimePassword",
            targets: ["OneTimePassword"]
        )
    ],
    dependencies: [
        .package(name: "Base32" ,url: "https://github.com/norio-nomura/Base32", from: "0.9.0")
    ],
    targets: [
        .target(
            name: "OneTimePassword",
            dependencies: ["Base32"],
            path: "Sources",
            exclude: [
                "Info.plist"
            ]
        ),
        .testTarget(
            name: "OnetimePasswordTests",
            dependencies: ["OneTimePassword"],
            path: "Tests",
            exclude: [
                "App",
                "Info.plist"
            ]
        ),
        .testTarget(
            name: "OneTimePasswordLegacyTests",
            dependencies: ["OneTimePassword"],
            path: "OneTimePasswordLegacyTests",
            exclude: [
                "Info.plist"
            ]
        )
    ],
    swiftLanguageVersions: [.v5, .v4_2]
)
