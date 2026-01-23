import SwiftUI
import AppKit

struct MultiItemDragView: NSViewRepresentable {
    let items: [ShelfItem]
    let onDragComplete: (() -> Void)?
    
    func makeNSView(context: Context) -> NSView {
        let view = MultiDragNSView()
        view.items = items
        view.onDragComplete = onDragComplete
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        if let dragView = nsView as? MultiDragNSView {
            dragView.items = items
            dragView.onDragComplete = onDragComplete
        }
    }
}

class MultiDragNSView: NSView {
    var items: [ShelfItem] = []
    var onDragComplete: (() -> Void)?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        startDragging(with: event)
    }
    
    private func startDragging(with event: NSEvent) {
        guard !items.isEmpty else { return }
        
        let urls = items.map { $0.url as NSURL }
        
        // Create dragging items with proper pasteboard items
        var draggingItems: [NSDraggingItem] = []
        for (index, url) in urls.enumerated() {
            let draggingItem = NSDraggingItem(pasteboardWriter: url)
            let image = items[index].displayImage
            image.size = NSSize(width: 42, height: 42)
            draggingItem.setDraggingFrame(NSRect(x: CGFloat(index * 5), y: CGFloat(index * 5), width: 42, height: 42), contents: image)
            draggingItems.append(draggingItem)
        }
        
        // Start dragging session - pasteboard will be set up in willBeginAt
        beginDraggingSession(with: draggingItems, event: event, source: self)
    }
}

extension MultiDragNSView: NSDraggingSource {
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .copy
    }
    
    func draggingSession(_ session: NSDraggingSession, willBeginAt screenPoint: NSPoint) {
        // Set up pasteboard with all file URLs
        let pasteboard = session.draggingPasteboard
        pasteboard.clearContents()
        
        let urls = items.map { $0.url as NSURL }
        
        // Write all file URLs to pasteboard
        pasteboard.writeObjects(urls)
    }
    
    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        // Remove items if drag completed successfully (not cancelled)
        if operation != [] {
            DispatchQueue.main.async {
                self.onDragComplete?()
            }
        }
    }
}
