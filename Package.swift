// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "OAuth2",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "OAuth2", type: .dynamic, targets: ["OAuth2"]),
        .library(name: "OAuth2Static", type: .static, targets: ["OAuth2"])
    ],
    dependencies: [
        .package(url: "git@github.com:janodevorg/APIClient.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/AutoLayout.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/CodableHelpers.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Dependency.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Keychain.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Report.git", branch: "main"),
        .package(url: "git@github.com:apple/swift-docc-plugin.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "OAuth2",
            dependencies: [
                .product(name: "APIClient", package: "APIClient"),
                .product(name: "AutoLayout", package: "AutoLayout"),
                .product(name: "CodableHelpers", package: "CodableHelpers"),
                .product(name: "Dependency", package: "Dependency"),
                .product(name: "Keychain", package: "Keychain"),
                .product(name: "Report", package: "Report")
            ],
            path: "sources/main"
        ),
        .testTarget(
            name: "OAuth2Tests",
            dependencies: ["OAuth2"],
            path: "sources/tests"
        )
    ]
)
