import PackageDescription

let package = Package(
    name: "vapor",
    dependencies: [
        .Package(url: "https://github.com/mpclarkson/printr.git", majorVersion: 0)
    ],
    testDependencies: [
        .Package(url: "https://github.com/Quick/Quick.git", versions: Version(0,0,0)..<Version(1,0,0)),
    ]
)
