import SwiftUI

// get notch dimainsion
extension NSScreen {
    var notchSize: CGSize? {
        guard #available(macOS 12, *) else {
            return nil
        }
        if safeAreaInsets.top != 0 {
            if let leftArea = auxiliaryTopLeftArea, let rightArea = auxiliaryTopRightArea {
                let totalWidth = frame.width
                let notchWidth = totalWidth - (leftArea.width + rightArea.width)
                let notchHeight = safeAreaInsets.top
                return CGSize(width: notchWidth, height: notchHeight)
            }
        }
        return nil
    }
}
