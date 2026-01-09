import SwiftUI

// Custom view for mouse tracking
class TrackingView: NSView {
    var onMouseEntered: (() -> Void)?
    var onMouseExited: (() -> Void)?
    private var trackingArea: NSTrackingArea?
    var collapsedNotchRect: CGRect = .zero {
        didSet {
            updateTrackingAreas()
        }
    }
    var isExpanded: Bool = false {
        didSet {
            updateTrackingAreas()
        }
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackingArea = trackingArea {
            removeTrackingArea(trackingArea)
        }
        
        // When expanded: track the entire expanded area so we can detect when mouse leaves
        let trackingRect = (isExpanded || collapsedNotchRect.isEmpty) ? bounds : collapsedNotchRect
        let options: NSTrackingArea.Options = [.activeAlways, .mouseEnteredAndExited]
        trackingArea = NSTrackingArea(rect: trackingRect, options: options, owner: self, userInfo: nil)
        addTrackingArea(trackingArea!)
    }
    
    override func mouseEntered(with event: NSEvent) {
        // Only trigger expansion when hovering over collapsed notch area
        if !isExpanded {
            onMouseEntered?()
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        onMouseExited?()
    }
}

