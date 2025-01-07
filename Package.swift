// swift-tools-version:5.5

import PackageDescription

let buildTests = false

extension Product {
  static func allTests() -> [Product] {
    if buildTests {
      return [.executable(name: "AllTestz", targets: ["AllTestz"])]
    } else {
      return []
    }
  }
}

extension Target {
    static func rxTarget(name: String, dependencies: [Target.Dependency]) -> Target {
        .target(
            name: name,
            dependencies: dependencies,
            resources: [.copy("PrivacyInfo.xcprivacy")]
        )
    }
}

extension Target {
  static func rxCocoa() -> [Target] {
    #if os(Linux)
      return [.rxTarget(name: "RxCocoa", dependencies: ["RxSwift", "RxRelay"])]
    #else
      return [.rxTarget(name: "RxCocoa", dependencies: ["RxSwift", "RxRelay", "RxCocoaRuntime"])]
    #endif
  }
    
  static func rxCocoaDynamic() -> [Target] {
    #if os(Linux)
      return [.rxTarget(name: "RxCocoa-Dynamic", dependencies: ["RxSwift", "RxRelay"])]
    #else
      return [.rxTarget(name: "RxCocoa-Dynamic", dependencies: ["RxSwift", "RxRelay", "RxCocoaRuntime"])]
    #endif
  }

  static func rxCocoaRuntime() -> [Target] {
    #if os(Linux)
      return []
    #else
      return [.rxTarget(name: "RxCocoaRuntime", dependencies: ["RxSwift"])]
    #endif
  }
    
  static func rxCocoaRuntimeDynamic() -> [Target] {
    #if os(Linux)
      return []
    #else
      return [.rxTarget(name: "RxCocoaRuntime-Dynamic", dependencies: ["RxSwift"])]
    #endif
  }

  static func allTests() -> [Target] {
    if buildTests {
      return [.target(name: "AllTestz", dependencies: ["RxSwift", "RxCocoa", "RxBlocking", "RxTest"])]
    } else {
      return []
    }
  }
}

let package = Package(
  name: "RxSwift",
  platforms: [.iOS(.v9), .macOS(.v10_10), .watchOS(.v3), .tvOS(.v9)],
  products: ([
    [
      .library(name: "RxSwift", targets: ["RxSwift"]),
      .library(name: "RxCocoa", targets: ["RxCocoa"]),
      .library(name: "RxRelay", targets: ["RxRelay"]),
      .library(name: "RxBlocking", targets: ["RxBlocking"]),
      .library(name: "RxTest", targets: ["RxTest"]),
//      .library(name: "RxSwift-Dynamic", type: .dynamic, targets: ["RxSwift-Dynamic"]),
//      .library(name: "RxCocoa-Dynamic", type: .dynamic, targets: ["RxCocoa-Dynamic"]),
//      .library(name: "RxRelay-Dynamic", type: .dynamic, targets: ["RxRelay-Dynamic"]),
//      .library(name: "RxBlocking-Dynamic", type: .dynamic, targets: ["RxBlocking-Dynamic"]),
//      .library(name: "RxTest-Dynamic", type: .dynamic, targets: ["RxTest-Dynamic"]),
    ],
    Product.allTests()
  ] as [[Product]]).flatMap { $0 },
  targets: ([
    [
      .rxTarget(name: "RxSwift", dependencies: []),
      .rxTarget(name: "RxSwift-Dynamic", dependencies: []),
    ],
    Target.rxCocoa(),
    Target.rxCocoaDynamic(),
    Target.rxCocoaRuntime(),
    Target.rxCocoaRuntimeDynamic(),
    [
      .rxTarget(name: "RxRelay", dependencies: ["RxSwift"]),
      .target(name: "RxBlocking", dependencies: ["RxSwift"]),
      .target(name: "RxTest", dependencies: ["RxSwift"]),
      .rxTarget(name: "RxRelay-Dynamic", dependencies: ["RxSwift"]),
      .target(name: "RxBlocking-Dynamic", dependencies: ["RxSwift"]),
      .target(name: "RxTest-Dynamic", dependencies: ["RxSwift"]),
    ],
    Target.allTests()
  ] as [[Target]]).flatMap { $0 },
  swiftLanguageVersions: [.v5]
)
