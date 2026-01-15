import SwiftUI
import Combine

final class ShelfManager: ObservableObject{
    
    static var shared = ShelfManager()
    
    @Published var items: [ShelfItem] = []
    
    // handle drop file
    func handleDrop(providers: [NSItemProvider]){
        for provider in providers{
            // get file url from provider
            _ = provider.loadObject(ofClass: URL.self, completionHandler: { url, error in
                guard let url = url else {return }
                
                // update ui in main thread
                DispatchQueue.main.async{
                    let newItem = ShelfItem(url: url)
                    // add item in the beginning
                    self.items.insert(newItem, at: 0)
                }
            })
        }
    }
    
    // remove file from container
    func remove( _ item: ShelfItem){
        items.removeAll{ $0.id == item.id }
    }
}
