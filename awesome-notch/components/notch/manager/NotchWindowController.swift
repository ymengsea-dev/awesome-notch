import SwiftUI
import AppKit

final class NotchWindowController {
    
    static let shared = NotchWindowController()
    
    private var window: NSWindow?
    private var trackingView: TrackingView?
    private var notchSize: CGSize?
    private var isAnimating = false
    private var mouseCheckTimer: Timer?
    private var dragMonitor: Any?
    
    private var tabManager = TabManager.share
    private let settings = SettingsManager()
    
    private var pendingExpandWorkItem: DispatchWorkItem?
    
    init() {
        // Listen for settings apply notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applySettings),
            name: NSNotification.Name("ApplyNotchSettings"),
            object: nil
        )
    }
    
    func show() {
        if window == nil {
            createWindow()
            startDragMonitor()
        }
        window?.makeKeyAndOrderFront(nil)
    }
    
    private func startDragMonitor() {
            // monitors the mouse even when it's NOT over your window
            dragMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged]) { [weak self] event in
                self?.handleGlobalDrag()
            }
        }
    
    private func handleGlobalDrag() {
            let pasteboard = NSPasteboard(name: .drag)
            
            // Check if what is being dragged is actually a file
            if pasteboard.canReadObject(forClasses: [NSURL.self], options: nil) {
                let mouseLocation = NSEvent.mouseLocation
                guard self.window != nil else { return }
                
                // If the mouse is close to the top of the screen where the notch is
                if mouseLocation.y > (NSScreen.main?.frame.height ?? 0) - 20 {
                    // Always switch to file tab when dragging a file
                    DispatchQueue.main.async {
                        self.tabManager.selectedTab = .file
                        
                        if !(self.trackingView?.isExpanded ?? false) {
                            self.setExpanded(true)
                            NotificationCenter.default.post(name: NSNotification.Name("NotchExpanded"), object: true)
                        }
                    }
                }
            }
        }
    
    func hide(){
        stopMouseCheckTimer()
        window?.orderOut(nil)
    }
    
    deinit {
        stopMouseCheckTimer()
        NotificationCenter.default.removeObserver(self)
        if let dragMonitor = dragMonitor {
            NSEvent.removeMonitor(dragMonitor)
        }
    }
     
    // create floating window for notch
    private func createWindow(){
        guard let screen = NSScreen.main else {return}
        
        // Initialize notch size from settings or screen
        let settingsWidth = CGFloat(settings.notchSize.rawValue)
        if let screenNotchSize = screen.notchSize {
            // Use screen notch height, but width from settings
            notchSize = CGSize(width: settingsWidth, height: screenNotchSize.height)
        } else {
            // Fallback: use proportional height
            notchSize = CGSize(width: settingsWidth, height: settingsWidth * 32 / 100)
        }
        
        let screenFrame = screen.frame
        
        let collapsedHeight: CGFloat = (notchSize?.height ?? 42)
        let expandedWidth: CGFloat = settingsWidth // width of notch when it expanded
        let expandedHeight: CGFloat = 140 // height of notch when it expanded
        
        // Always use expanded size for window frame to prevent mouse tracking issues
        let x = (screenFrame.width - expandedWidth) / 2
        let y = screenFrame.height - screen.safeAreaInsets.top + 6 - (expandedHeight - collapsedHeight)
                 
        let frame = NSRect(
            x: x,
            y: y,
            width: expandedWidth,
            height: expandedHeight
        )
        
        let hostingView = NSHostingView(rootView: NotchView {
            NotchTabs()
        }.environmentObject(settings))
        
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
            self.pendingExpandWorkItem?.cancel()
            let workItem = DispatchWorkItem { [weak self] in
                    guard let self = self else { return }
                    self.setExpanded(true)
                    NotificationCenter.default.post(name: NSNotification.Name("NotchExpanded"), object: true)
                }
            self.pendingExpandWorkItem = workItem
            DispatchQueue.main
                .asyncAfter(
                    deadline: .now() + settings.expandSensitivity ,
                    execute: workItem
                )
        }
        trackingView.onMouseExited = { [weak self] in
            guard let self = self else { return }
            
            self.pendingExpandWorkItem?.cancel()
            self.pendingExpandWorkItem = nil
            
            // Only handle mouse exit when expanded (to collapse)
            guard let trackingView = self.trackingView, trackingView.isExpanded else { return }
            
            // Add delay from settings to prevent flicker when mouse moves during animation
            let delay = self.settings.expandSensitivity
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
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
        window.registerForDraggedTypes([.fileURL])

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
                tabManager.selectedTab = .home
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
        // Timer automatically runs on current run loop (main thread)
        mouseCheckTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            self?.checkMousePosition()
        }
    }
    
    private func stopMouseCheckTimer() {
        mouseCheckTimer?.invalidate()
        mouseCheckTimer = nil
    }
    
    func setExpanded(_ expanded: Bool){
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
        
        // Ensure notch size is initialized from settings
        let settingsWidth = CGFloat(settings.notchSize.rawValue)
        if let screenNotchSize = screen.notchSize {
            // Use screen notch height, but width from settings
            notchSize = CGSize(width: settingsWidth, height: screenNotchSize.height)
        } else {
            // Fallback: use proportional height
            notchSize = CGSize(width: settingsWidth, height: settingsWidth * 32 / 100)
        }
        
        let safeInsets = screen.safeAreaInsets
        let screenFrame = screen.frame

        // Add extra height to extend below physical notch for displaying content
        let collapsedHeight = (notchSize?.height ?? 42)
        let expandedWidth = settingsWidth
        let expandedHeight: CGFloat = 140
        
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
    
    func showSettingsWindow(){
        NSApplication.shared.activate(ignoringOtherApps: true)
        if let window = NSApp.windows.first(where: { $0.identifier?.rawValue == "SettingsWindow" }) {
                window.makeKeyAndOrderFront(nil)
                return
            }
        let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 700, height: 500),
                styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
        
        window.identifier = NSUserInterfaceItemIdentifier("SettingsWindow")
        window.titleVisibility = .hidden // Hides the title text
        window.titlebarAppearsTransparent = true
        window.toolbarStyle = .unified // Aligns buttons with the sidebar
        
        window.isReleasedWhenClosed = false
        window.center()
        window.contentView = NSHostingView(rootView: SettingsView())
        window.makeKeyAndOrderFront(nil)
    }
    
    @objc private func applySettings() {
        // Recreate window with new settings
        let wasVisible = window?.isVisible ?? false
        if window != nil {
            window?.orderOut(nil)
            window = nil
            trackingView = nil
        }
        if wasVisible {
            createWindow()
            show()
        }
    }
    
}
