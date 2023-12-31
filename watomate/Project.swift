import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "Watomate",
                          destinations: .iOS,
                          dependencies: [
                            .external(name: "SnapKit"),
                            .external(name: "Alamofire")
                         ])
