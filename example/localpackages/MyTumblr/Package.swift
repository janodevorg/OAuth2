// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "MyTumblr",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MyTumblr", type: .dynamic, targets: ["MyTumblr"]),
        .library(name: "MyTumblrStatic", type: .static, targets: ["MyTumblr"])
    ],
    dependencies: [
        .package(url: "git@github.com:janodevorg/APIClient.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/AutoLayout.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/CodableHelpers.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Coordinator.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/CoreDataStack.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Dependency.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Keychain.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/Kit.git", branch: "main"),
        .package(path: "../../.."),
        .package(url: "git@github.com:janodevorg/TumblrNPF.git", branch: "main"),
        .package(url: "git@github.com:janodevorg/TumblrNPFPersistence.git", branch: "main"),
        .package(url: "git@github.com:apple/swift-docc-plugin.git", branch: "main")
    ],
    targets: [
        .target(
            name: "MyTumblr",
            dependencies: [
                .product(name: "APIClient", package: "APIClient"),
                .product(name: "AutoLayout", package: "AutoLayout"),
                .product(name: "CodableHelpers", package: "CodableHelpers"),
                .product(name: "Coordinator", package: "Coordinator"),
                .product(name: "CoreDataStack", package: "CoreDataStack"),
                .product(name: "Dependency", package: "Dependency"),
                .product(name: "Keychain", package: "Keychain"),
                .product(name: "Kit", package: "Kit"),
                .product(name: "OAuth2", package: "OAuth2"),
                .product(name: "TumblrNPF", package: "TumblrNPF"),
                .product(name: "TumblrNPFPersistence", package: "TumblrNPFPersistence")
            ],
            path: "sources/main",
            exclude: [
                "tumblr-user.txt"
            ],
            resources: [
                .copy("resources/fonts/Gibson-bold.ttf"),
                .copy("resources/fonts/Gibson-bolditalic.ttf"),
                .copy("resources/fonts/Gibson-regular.ttf"),
                .copy("resources/fonts/Gibson-regularitalic.ttf"),
                .copy("resources/fonts/RugeBoogie-Regular.ttf"),
            ]
        ),
        .testTarget(
            name: "MyTumblrTests",
            dependencies: ["MyTumblr"],
            path: "sources/tests",
            resources: [
                .copy("resources/401.json"),
                .copy("resources/APIError.json"),
                .copy("resources/swift-index.json"),
                .copy("resources/tumblr1.json"),
                .copy("resources/tumblr2.json"),
                .copy("resources/tumblr3.json")
            ]
        )
    ]
)
