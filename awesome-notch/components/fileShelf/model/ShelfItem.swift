import SwiftUI

struct ShelfItem: Identifiable{
    let id = UUID()
    let url: URL
    
    var icon: NSImage{
        NSWorkspace.shared.icon(forFile: url.path)
    }
}
