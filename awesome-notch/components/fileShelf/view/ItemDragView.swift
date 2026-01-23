import SwiftUI
import AppKit

struct ItemDragView: NSViewRepresentable {
    let item: ShelfItem
    let onDragComplete: () -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = ItemDragNSView()
        view.item = item
        view.onDragComplete = onDragComplete
        view.wantsLayer = true
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        if let dragView = nsView as? ItemDragNSView {
            dragView.item = item
            dragView.onDragComplete = onDragComplete
        }
    }
}

class ItemDragNSView: NSView {
    var item: ShelfItem?
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
        guard let item = item else { return }
        
        let url = item.url as NSURL
        let draggingItem = NSDraggingItem(pasteboardWriter: url)
        let image = item.displayImage
        image.size = NSSize(width: 42, height: 42)
        draggingItem.setDraggingFrame(NSRect(x: 0, y: 0, width: 42, height: 42), contents: image)
        
        beginDraggingSession(with: [draggingItem], event: event, source: self)
    }
}

extension ItemDragNSView: NSDraggingSource {
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .copy
    }
    
    func draggingSession(_ session: NSDraggingSession, willBeginAt screenPoint: NSPoint) {
        // Dragging started
    }
    
    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        // Remove item if drag completed successfully (not cancelled)
        if operation != [] {
            DispatchQueue.main.async {
                self.onDragComplete?()
            }
        }
    }
}
