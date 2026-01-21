import SwiftUI

enum NotchSize: CGFloat, CaseIterable {
    case small = 450 // default
    case medium = 500
    case large = 600

    var title: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
}
