import PackageDescription

let package = Package(
    name: "vapor",
    dependencies: [
       .Package(url: "https://github.com/mpclarkson/printr.git", versions: Version(0,0,0)..<Version(1,0,0)),
   ]
)
