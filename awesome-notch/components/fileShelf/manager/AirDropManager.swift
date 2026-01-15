import SwiftUI
import Combine

final class AirDropManager: NSObject, ObservableObject, NSSharingServiceDelegate{
    
    static var shared = AirDropManager()
    
    // handle airdrop func
    func handleAirDrop(providers: [NSItemProvider]){
        for provider in providers {
            _ = provider.loadObject(ofClass: URL.self, completionHandler: { url, _ in
                if let url = url {
                    DispatchQueue.main.async {
                        self.triggerAirDrop(for: url)
                    }
                }
            })
        }
    }
    
    // trigger air drop func
    func triggerAirDrop(for url: URL) {
        let picker = NSSharingServicePicker(items: [url])
        
        // Look for our specific AirDrop helper window
        if let window = NSApp.windows.first(where: { $0.identifier?.rawValue == "AirDropWindow" }),
           let contentView = window.contentView {
            picker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
        } else {
            // Fallback to any visible window if helper isn't found
            if let window = NSApp.windows.first(where: { $0.isVisible }),
               let contentView = window.contentView {
                picker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
            }
        }
    }
}
