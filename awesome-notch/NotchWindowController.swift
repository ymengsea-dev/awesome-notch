import SwiftUI
import AppKit

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

final class NotchWindowController {
    
    static let shared = NotchWindowController()
    
    private var window: NSWindow?
    private var trackingView: TrackingView?
    private var notchSize: CGSize?
    private var isAnimating = false
    private var hoverDebounceTimer: Timer?
    private var mouseCheckTimer: Timer?
    
    func show() {
        if window == nil {
            createWindow()
        }
        window?.makeKeyAndOrderFront(nil)
    }
    
    func hide(){
        stopMouseCheckTimer()
        hoverDebounceTimer?.invalidate()
        hoverDebounceTimer = nil
        window?.orderOut(nil)
    }
    
    deinit {
        stopMouseCheckTimer()
        hoverDebounceTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    // create floating window for notch
    private func createWindow(){
        guard let screen = NSScreen.main else {return}
        
        // Initialize notch size on first window creation
        if notchSize == nil {
            notchSize = screen.notchSize
        }
        
        let safeInserts  = screen.safeAreaInsets
        let screenFrame = screen.frame
        
        // Use actual notch width if available, otherwise fallback to 180
        let collapsedHeight: CGFloat = notchSize?.height ?? 42
        let expandedWidth: CGFloat = 320.0 // width of notch when it expanded
        let expandedHeight: CGFloat = 120 // height of notch when it expanded
        
        // Always use expanded size for window frame to prevent mouse tracking issues
        let x = (screenFrame.width - expandedWidth) / 2
        let y = screenFrame.height - safeInserts.top + 6 - (expandedHeight - collapsedHeight)
                 
        let frame = NSRect(
            x: x,
            y: y,
            width: expandedWidth,
            height: expandedHeight
        )
        
        let hostingView = NSHostingView(rootView: NotchView())
        
        // Create tracking view wrapper matching window size
        let trackingView = TrackingView(frame: NSRect(x: 0, y: 0, width: expandedWidth, height: expandedHeight))
        self.trackingView = trackingView
        
        // Calculate collapsed notch rect (centered horizontally, at the top)
        let collapsedNotchWidth = notchSize?.width ?? 180
        let collapsedNotchHeight = collapsedHeight
        let collapsedNotchX = (expandedWidth - collapsedNotchWidth) / 2
        let collapsedNotchY = expandedHeight - collapsedNotchHeight
        trackingView.collapsedNotchRect = NSRect(
            x: collapsedNotchX,
            y: collapsedNotchY,
            width: collapsedNotchWidth,
            height: collapsedNotchHeight
        )
        
        trackingView.onMouseEntered = { [weak self] in
            guard let self = self, !(self.trackingView?.isExpanded ?? false) else { return }
            self.setExpanded(true)
            NotificationCenter.default.post(name: NSNotification.Name("NotchExpanded"), object: true)
        }
        trackingView.onMouseExited = { [weak self] in
            guard let self = self else { return }
            // Only handle mouse exit when expanded (to collapse)
            guard let trackingView = self.trackingView, trackingView.isExpanded else { return }
            
            // Add small delay to prevent flicker when mouse moves during animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                // The periodic timer will handle checking, but we can also check here
                self?.checkMousePosition()
            }
        }
        
        trackingView.addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: trackingView.topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: trackingView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: trackingView.trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: trackingView.bottomAnchor)
        ])
        
        let window = NSWindow(
            contentRect: frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.contentView = trackingView
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false

        window.level = .statusBar
        window.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary,
            .ignoresCycle
        ]
        
        // Monitor application activation to handle Spaces transitions
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: NSApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidResignActive),
            name: NSApplication.didResignActiveNotification,
            object: nil
        )

        self.window = window
    }
    
    @objc private func applicationDidBecomeActive() {
        // When application becomes active, check mouse position
        // This helps recover from Spaces transitions
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.checkMousePosition()
        }
    }
    
    @objc private func applicationDidResignActive() {
        // When application loses focus (e.g., during Spaces transition), collapse if expanded
        if trackingView?.isExpanded == true {
            setExpanded(false)
            NotificationCenter.default.post(name: NSNotification.Name("NotchExpanded"), object: false)
        }
    }
    
    private func checkMousePosition() {
        guard let window = window, let trackingView = trackingView else { return }
        
        let mouseLocation = NSEvent.mouseLocation
        let windowFrame = window.frame
        
        if trackingView.isExpanded {
            // If expanded, check if mouse is still in window
            if !windowFrame.contains(mouseLocation) {
                setExpanded(false)
                NotificationCenter.default.post(name: NSNotification.Name("NotchExpanded"), object: false)
            }
        } else {
            // If collapsed, check if mouse is over the collapsed notch area
            let windowMouseLocation = NSPoint(
                x: mouseLocation.x - windowFrame.origin.x,
                y: mouseLocation.y - windowFrame.origin.y
            )
            // Convert to view coordinates (flip Y)
            let viewMouseLocation = NSPoint(
                x: windowMouseLocation.x,
                y: windowFrame.height - windowMouseLocation.y
            )
            if trackingView.collapsedNotchRect.contains(viewMouseLocation) {
                setExpanded(true)
                NotificationCenter.default.post(name: NSNotification.Name("NotchExpanded"), object: true)
            }
        }
    }
    
    private func startMouseCheckTimer() {
        stopMouseCheckTimer()
        // Check mouse position periodically when expanded to handle gesture interruptions
        mouseCheckTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            self?.checkMousePosition()
        }
    }
    
    private func stopMouseCheckTimer() {
        mouseCheckTimer?.invalidate()
        mouseCheckTimer = nil
    }
    
    // set expanding
    func setExpanded(_ expanded: Bool){
        // Cancel any pending debounce timer
        hoverDebounceTimer?.invalidate()
        
        // Ignore if already animating
        guard !isAnimating, let window, let screen = NSScreen.main else { return }
        
        // Update tracking view expanded state
        trackingView?.isExpanded = expanded
        
        // Start/stop periodic mouse checking when expanded
        if expanded {
            startMouseCheckTimer()
        } else {
            stopMouseCheckTimer()
        }
        
        // Ensure notch size is initialized
        if notchSize == nil {
            notchSize = screen.notchSize
        }
        
        let safeInsets = screen.safeAreaInsets
        let screenFrame = screen.frame

        let collapsedHeight = notchSize?.height ?? 42
        let expandedWidth = 320.0
        let expandedHeight: CGFloat = 120
        
        // Window always stays at expanded size, we just animate the visual content
        // This prevents mouse tracking issues
        let width = expandedWidth
        let height = expandedHeight

        let x = (screenFrame.width - width) / 2
        let y = screenFrame.height - safeInsets.top + 6 - (expandedHeight - collapsedHeight)

        let newFrame = NSRect(x: x, y: y, width: width, height: height)
        
        // Mark as animating
        isAnimating = true
        
        // Animate with completion handler
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            window.animator().setFrame(newFrame, display: true)
        }, completionHandler: {
            self.isAnimating = false
        })
    }
}


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
