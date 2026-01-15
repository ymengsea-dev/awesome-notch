import SwiftUI
import Combine
import UniformTypeIdentifiers

final class AirDropManager: NSObject, ObservableObject, NSSharingServiceDelegate {
    
    static var shared = AirDropManager()
    
    // handle air drop
    func handleAirDrop(providers: [NSItemProvider]) {
        for provider in providers {
            provider.loadDataRepresentation(forTypeIdentifier: UTType.fileURL.identifier) { data, error in
                guard let data = data,
                      let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                
                DispatchQueue.main.async {
                    self.triggerAirDrop(for: url)
                }
            }
        }
    }
    
    // trigger airdrop servicie
    func triggerAirDrop(for url: URL) {
        // Specifically create the AirDrop service
        guard let service = NSSharingService(named: NSSharingService.Name.sendViaAirDrop) else {
            print("AirDrop not available")
            return
        }
        service.delegate = self
        if service.canPerform(withItems: [url]) {
            service.perform(withItems: [url])
        }
    }
    
}
