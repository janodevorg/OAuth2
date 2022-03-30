// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "MyTeamwork",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MyTeamwork", type: .dynamic, targets: ["MyTeamwork"]),
        .library(name: "MyTeamworkStatic", type: .static, targets: ["MyTeamwork"])
    ],
    dependencies: [
        .package(url: "git@github.com:janodevorg/APIClient.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/AutoLayout.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/CodableHelpers.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Coordinator.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Dependency.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Keychain.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Kit.git", branch: "main"),
        .package(path: "../../.."),
        .package(url: "git@github.com:apple/swift-docc-plugin.git", branch: "main")
    ],
    targets: [
        .target(
            name: "MyTeamwork",
            dependencies: [
                .product(name: "APIClient", package: "APIClient"),
                .product(name: "AutoLayout", package: "AutoLayout"),
                .product(name: "CodableHelpers", package: "CodableHelpers"),
                .product(name: "Coordinator", package: "Coordinator"),
                .product(name: "Dependency", package: "Dependency"),
                .product(name: "Keychain", package: "Keychain"),
                .product(name: "Kit", package: "Kit"),
                .product(name: "OAuth2", package: "OAuth2")
            ],
            path: "sources/main",
            exclude: []
        ),
        .testTarget(
            name: "MyTeamworkTests",
            dependencies: ["MyTeamwork"],
            path: "sources/tests"
        )
    ]
)
