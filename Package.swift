// swift-tools-version:5.3
import PackageDescription

#if arch(arm) || arch(arm64)
let platforms: [SupportedPlatform]? = [
    .macOS(.v11),
    .iOS(.v14),
    .watchOS(.v4),
    .tvOS(.v14)
]

let exclude: [String] = ["coreml"]
let additionalSettings: [CSetting] = [
    .unsafeFlags(["-fno-objc-arc"]),
    .define("GGML_USE_METAL")
]
#else
let platforms: [SupportedPlatform]? = nil
let exclude: [String] = ["Sources/whisper/ggml-metal.m", "Sources/whisper/ggml-metal.metal"]
let additionalSettings: [CSetting] = []
#endif

let package = Package(
    name: "whisper.spm",
    platforms: platforms,
    products: [
        .library(
            name: "whisper",
            targets: ["whisper"]
        ),
        .library(
            name: "whispercpp",
            targets: ["whispercpp"]
        )
    ],
    targets: [
        .target(
            name: "whisper",
            exclude: exclude,
            publicHeadersPath: ".",
            cSettings: [
                .unsafeFlags(["-Wno-shorten-64-to-32"]),
                .define("GGML_USE_ACCELERATE")
            ] + additionalSettings,
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        ),
        .target(
            name: "whispercpp",
            dependencies: ["whisper"],
            publicHeadersPath: "include"
        ),
        .target(name: "test-objc", dependencies: ["whispercpp"]),
        .target(name: "test-swift", dependencies: ["whispercpp"])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
