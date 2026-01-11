import SwiftUI
import UniformTypeIdentifiers
import AppKit

struct NotchShelfView: View {
    @ObservedObject var shelfManager = ShelfManager.shared
    @State var isDraggingOver = false
    
    var body: some View {
        HStack{
            if(shelfManager.items.isEmpty){
                Text("drop file over here")
                    .foregroundStyle(.white)
                    .padding()
                    .background(.gray)
            }else {
                ForEach(shelfManager.items) { item in
                    Image(nsImage: item.icon)
                        .onDrag {
                            NSItemProvider(object: item.url as NSURL)
                        }
                        .overlay(alignment: .topTrailing) {
                            Button{
                                shelfManager.remove(item)
                            }label: {
                                Image(systemName: "xmark.circle")
                                    .foregroundStyle(.white)
                            }
                        }
                }
            }
        }
        .background(isDraggingOver ? Color.white.opacity(0.1) : Color.clear)
        .cornerRadius(15)
        .onDrop(of: [.fileURL], isTargeted: $isDraggingOver){ providers in
            shelfManager.handleDrop(providers: providers)
            return true
        }
    }
}
