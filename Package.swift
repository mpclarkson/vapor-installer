import PackageDescription

let package = Package(
    name: "vapor",
    dependencies: [
        .Package(url: "https://github.com/mpclarkson/printr.git", majorVersion: 0)
    ]
)
