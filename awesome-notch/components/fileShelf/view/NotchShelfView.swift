import SwiftUI
import UniformTypeIdentifiers
import AppKit

struct NotchShelfView: View {
    @StateObject var shelfManager = ShelfManager.shared
    @State var isDraggingOver = false
    
    var body: some View {
        HStack{
            if(shelfManager.items.isEmpty){
                VStack(spacing: 5){
                    Image(systemName: "tray.and.arrow.down.fill")
                        .font(.title3)
                        .foregroundStyle(.gray)
                    Text("Drop file here")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
                .background(Color.white.opacity(0.001))
                .foregroundStyle(isDraggingOver ? .blue : .gray)
                .padding(.horizontal, 30)
                .padding(.vertical, 14)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style: StrokeStyle(
                            lineWidth: 3,
                            dash: [10,5]
                        ))
                        .foregroundStyle(isDraggingOver ? .blue : .gray)
                }
                .onDrop(of: [.fileURL], isTargeted: $isDraggingOver){ providers in
                    shelfManager.handleDrop(providers: providers)
                    return true
                }
            }else {
                HStack{
                    ForEach(shelfManager.items) { item in
                        Image(nsImage: item.icon)
                            .resizable()
                            .scaledToFit()
                            .onDrag {
                                NSItemProvider(object: item.url as NSURL)
                            }
                            .overlay(alignment: .topTrailing) {
                                HStack{
                                    Button{
                                        shelfManager.remove(item)
                                    }label: {
                                        Image(systemName: "xmark.circle")
                                            .foregroundStyle(.white)
                                            .padding(3)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .position(x: 40, y: 0)
                            }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 14)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style: StrokeStyle(
                            lineWidth: 3,
                            dash: [10,5]
                        ))
                        .foregroundStyle(isDraggingOver ? .blue : .gray)
                }
                .onDrop(of: [.fileURL], isTargeted: $isDraggingOver){ providers in
                    shelfManager.handleDrop(providers: providers)
                    return true
                }
            }
        }
    }
}

#Preview {
    NotchShelfView()
}
