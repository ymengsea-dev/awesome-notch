import SwiftUI
import UniformTypeIdentifiers

struct ShelfItem: Identifiable{
    let id = UUID()
    let url: URL
    
    var icon: NSImage{
        NSWorkspace.shared.icon(forFile: url.path)
    }
    
    var isImage: Bool {
        guard let type = UTType(filenameExtension: url.pathExtension) else {
            return false
        }
        return type.conforms(to: .image)
    }
    
    var previewImage: NSImage? {
        guard isImage else { return nil }
        return NSImage(contentsOf: url)
    }
    
    var displayImage: NSImage {
        previewImage ?? icon
    }
}
