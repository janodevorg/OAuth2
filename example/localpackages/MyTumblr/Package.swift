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
        .package(url: "git@github.com:janodevorg/APIClient.git", from: "1.0.0"),
        .package(url: "git@github.com:janodevorg/AutoLayout.git", from: "1.0.0"),
        .package(url: "git@github.com:janodevorg/CodableHelpers.git", from: "1.0.0"),
        .package(url: "git@github.com:janodevorg/Coordinator.git", from: "1.0.0"),
        .package(url: "git@github.com:janodevorg/CoreDataStack.git", from: "1.0.0"),
        .package(url: "git@github.com:janodevorg/Dependency.git", from: "1.0.0"),
        .package(url: "git@github.com:janodevorg/Keychain.git", from: "1.0.0"),
        .package(url: "git@github.com:janodevorg/Kit.git", from: "1.0.0"),
        .package(path: "../../.."),
        .package(url: "git@github.com:janodevorg/TumblrNPF.git", from: "1.0.0"),
        .package(url: "git@github.com:janodevorg/TumblrNPFPersistence.git", from: "1.0.0"),
        .package(url: "git@github.com:apple/swift-docc-plugin.git", from: "1.0.0")
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
