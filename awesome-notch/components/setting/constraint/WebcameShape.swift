import SwiftUI

enum WebcameShape: String, CaseIterable {
    case roundedRectangle = "roundedRectangle"
    case circle = "circle"
    case rectangle = "rectangle"

    var title: String {
        switch self {
        case .roundedRectangle: return "Rounded Rectangle"
        case .circle: return "Circle"
        case .rectangle: return "Rectangle"
        }
    }
}
