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
            // GPBProtocolBuffers.m 是 umbrella source — 把所有 GPB*.m + GPB*.pbobjc.m
            // 都 #import 进来 (用法见 Google 文档 "若不加 dependency 可只编这个一个文件"),
            // SPM 单文件编译时如果同时编 umbrella .m 又编子 .m 会出 duplicate symbol 612 处.
            // 排除掉 umbrella, 让 SPM 单文件路径成为唯一来源.
            exclude: [
                "protobuf-runtime/GPBProtocolBuffers.m",
            ],
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
