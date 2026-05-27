// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVGAPlayer",
    platforms: [
        // 跟随主项目 iOS 13 部署目标 (ZipArchive 2.5.x 也需要 13+)
        .iOS("13.0")
    ],
    products: [
        .library(name: "SVGAPlayer", targets: ["SVGAPlayer"])
    ],
    dependencies: [
        // ZipArchive 2.5.x 整段需要 iOS 15.5; 锁到 2.4.x 保 iOS 13
        // (CocoaPods 路径用的也是 SSZipArchive 2.4.3, API 兼容)
        .package(url: "https://github.com/ZipArchive/ZipArchive.git", "2.4.0"..<"2.5.0")
    ],
    targets: [
        // 拆成 2 个 target:
        // - SVGAPlayerProto: protoc 生成代码 (Svga.pbobjc) + Google protobuf OC runtime, MRC (-fno-objc-arc)
        //   Google 的 OC protobuf 运行时是 MRC 实现, 必须独立目标关掉 ARC
        // - SVGAPlayer: 上层 ARC 业务代码, 依赖 SVGAPlayerProto + ZipArchive
        .target(
            name: "SVGAPlayerProto",
            path: "Source/SVGAPlayerProto",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("pbobjc"),
                .headerSearchPath("protobuf-runtime"),
                .unsafeFlags([
                    "-fno-objc-arc",
                    "-Wno-deprecated-declarations",
                    "-Wno-unused-function",
                ])
            ]
        ),
        .target(
            name: "SVGAPlayer",
            dependencies: [
                .target(name: "SVGAPlayerProto"),
                .product(name: "ZipArchive", package: "ZipArchive"),
            ],
            path: "Source/SVGAPlayer",
            publicHeadersPath: "include"
        )
    ]
)
