import ProjectDescription

extension Project {
    public static func app(name: String, destinations: Destinations, infoPlist: [String: Plist.Value], dependencies: [TargetDependency]) -> Project {
        var targets = makeAppTargets(name: name,
                                     destinations: destinations,
                                     infoPlist: infoPlist,
                                     dependencies: dependencies
        )
        return Project(name: name,
                       organizationName: "tuist.io",
                       targets: targets)
    }

    // MARK: - Private
    
    private static func makeAppTargets(name: String, destinations: Destinations, infoPlist: [String: Plist.Value], dependencies: [TargetDependency]) -> [Target] {

        let mainTarget = Target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: "io.waffle.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**"],
            dependencies: dependencies
        )
        return [mainTarget]
    }
}
