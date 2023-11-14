// swift-tools-version:5.3
import PackageDescription

// old target
//.target(name: "whisper", dependencies:[], cSettings: [
//    .unsafeFlags([
//        "-O3",
//        "-fno-objc-arc",
//        "-DGGML_USE_ACCELERATE",
//        "-DGGML_USE_METAL",
//        "-DWHISPER_USE_COREML",
//        "-DWHISPER_COREML_ALLOW_FALLBACK"])
//]),

#if arch(arm) || arch(arm64)
let platforms: [SupportedPlatform]? = [
    .macOS(.v11),
    .iOS(.v14),
    .watchOS(.v4),
    .tvOS(.v14)
]

let exclude: [String] = []
let additionalSources: [String] = []
let additionalSettings: [CSetting] = [
    .define("GGML_SWIFT"),
    .define("GGML_USE_METAL")
]
let additionalDependencies: [Target.Dependency] = ["whisper-metal"]

let additionalTargets: [Target] = [
  Target.target(
      name: "whisper-metal",
      path: ".",
      sources: [
          "Sources/whisper/ggml-metal.m",
          "Sources/whisper/ggml-metal.metal"
      ],
      cSettings: [
          .unsafeFlags(["-Wno-shorten-64-to-32"]),
          .define("GGML_USE_ACCELERATE"),
          .define("WHISPER_USE_COREML"),
          .define("WHISPER_COREML_ALLOW_FALLBACK"),
          .unsafeFlags(["-fno-objc-arc"])
      ] + additionalSettings,
      linkerSettings: [
          .linkedFramework("Accelerate")
      ])
]

#else
let platforms: [SupportedPlatform]? = nil
let exclude: [String] = []
let additionalSources: [String] = []
let additionalSettings: [CSetting] = []
let additionalDependencies: [Target.Dependency] = []
let additionalTargets: [Target] = []
#endif

let package = Package(
    name: "whisper.spm",
    platforms: platforms,
    products: [
        .library(
            name: "whisper",
            targets: ["whisper"])
    ],
    targets: [
        .target(
            name: "whisper",
            dependencies: [] + additionalDependencies,
            path: ".",
            exclude: exclude,
            sources: [
                "Sources/whisper/ggml.c",
                "Sources/whisper/ggml-alloc.c",
                "Sources/whisper/ggml-backend.c",
                "Sources/whisper/ggml-quants.c",
                "Sources/whisper/coreml/whisper-encoder-impl.m",
                "Sources/whisper/coreml/whisper-encoder.mm",
                "Sources/whisper/whisper.cpp",
            ] + additionalSources,
            publicHeadersPath: "Sources/whisper/include",
            cSettings: [
                .unsafeFlags(["-Wno-shorten-64-to-32"]),
                .define("GGML_USE_ACCELERATE"),
                .define("GGML_USE_METAL"),
                .define("WHISPER_USE_COREML"),
                .define("WHISPER_COREML_ALLOW_FALLBACK")
            ] + additionalSettings,
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        ),
        .target(name: "test-objc",  dependencies:["whisper"]),
        .target(name: "test-swift", dependencies:["whisper"])
    ] + additionalTargets,
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
