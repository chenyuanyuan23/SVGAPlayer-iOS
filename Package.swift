// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVGAPlayer",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "SVGAPlayer", targets: ["SVGAPlayer"])
    ],
    dependencies: [
        .package(url: "https://github.com/ZipArchive/ZipArchive.git", from: "2.5.5")
    ],
    targets: [
        .target(
            name: "SVGAPlayer",
            dependencies: [
                .product(name: "ZipArchive", package: "ZipArchive")
            ],
            path: "Source",
            // 注意:
            // - SVGA*.h 已移到 Source/include/ (公共 API)
            // - pbobjc/ 是 protoc 生成代码 (Svga.pbobjc.h/m), 仅 SVGAPlayer 内部用
            // - protobuf-runtime/ 是 Google protobuf OC runtime (76 个文件) inline 进来
            //   - 因为 Google 没提供 SPM 支持, 又是 BSD-3 自由 redistribute
            //   - 版本: v27.5
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("pbobjc"),
                .headerSearchPath("protobuf-runtime"),
                // 关闭 Google protobuf runtime 的一些 strict warning
                .unsafeFlags(["-Wno-deprecated-declarations", "-Wno-unused-function"])
            ]
        )
    ]
)
