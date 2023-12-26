// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AuroraEditorLanguage",
    products: [
        .library(
            name: "AuroraEditorLanguage",
            targets: ["AuroraEditorLanguage"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ChimeHQ/SwiftTreeSitter.git",
            exact: "0.7.1"
        )
    ],
    targets: [
        .target(
            name: "AuroraEditorLanguage",
            dependencies: [
                "AuroraEditorSupportedLanguages",
                "SwiftTreeSitter"
            ],
            resources: [
                .copy("Resources")
            ],
            linkerSettings: [.linkedLibrary("c++")]
        ),
        .binaryTarget(
            name: "AuroraEditorSupportedLanguages",
            path: "AuroraEditorSupportedLanguages.xcframework.zip"
        ),
    ]
)
