import SwiftUI
import UniformTypeIdentifiers
import AppKit

struct NotchShelfView: View {
    @ObservedObject var shelfManager = ShelfManager.shared
    @State var isDraggingOver = false
    @EnvironmentObject var settings: SettingsManager
    
    var body: some View {
        HStack{
            if(shelfManager.items.isEmpty){
                VStack(spacing: 5){
                    ZStack{
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(style: StrokeStyle(
                                lineWidth: 2,
                                dash: [10,7]
                            ))
                            .foregroundStyle(
                                isDraggingOver ? .blue.opacity(0.6) : .gray.opacity(0.5)
                            )
                        VStack{
                            Image(systemName: "tray.and.arrow.down.fill")
                                .font(.title3)
                                .foregroundStyle(
                                    isDraggingOver ? .blue.opacity(0.6) : .gray.opacity(0.6)
                                )
                            Text("Drop file here")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    isDraggingOver ? .blue.opacity(0.6) : .gray.opacity(0.6)
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(isDraggingOver ? .blue.opacity(0.6) : .gray.opacity(0.5))
                .onDrop(of: [.fileURL], isTargeted: $isDraggingOver){ providers in
                    shelfManager.handleDrop(providers: providers)
                    return true
                }
            }else {
                    GeometryReader { geometry in
                        ScrollView(.horizontal, showsIndicators: false){
                            VStack {
                                HStack(alignment: .center, spacing: 10){
                                    ForEach(shelfManager.items) { item in
                                        ZStack {
                                            Image(nsImage: item.displayImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 42, height: 42)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                .allowsHitTesting(false)
                                            
                                            ItemDragView(item: item) {
                                                shelfManager.remove(item)
                                            }
                                            .frame(width: 42, height: 42)
                                        }
                                        .overlay(alignment: .topTrailing) {
                                            HStack{
                                                Button{
                                                    shelfManager.remove(item)
                                                }label: {
                                                    Image(systemName: "xmark")
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(.white)
                                                        .padding(3)
                                                }
                                                .buttonStyle(.plain)
                                            }
                                            .position(x: 40, y: 5)
                                        }
                                    }
                                }
                                .padding(.horizontal, 10)
                            }
                            .frame(height: geometry.size.height)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(style: StrokeStyle(
                                lineWidth: 2,
                                dash: [10,2]
                            ))
                            .foregroundStyle(
                                isDraggingOver ? .blue.opacity(0.6) : .gray.opacity(0.5)
                            )
                    }
                    .overlay(alignment: .bottomTrailing) {
                        if settings.isGrabBunch {
                            if !shelfManager.items.isEmpty {
                                ZStack {
                                    MultiItemDragView(items: shelfManager.items) {
                                        // Remove all items when drag completes successfully
                                        shelfManager.items.forEach { item in
                                            shelfManager.remove(item)
                                        }
                                    }
                                    .frame(width: 24, height: 24)
                                    
                                    Image(systemName: "hand.raised.fill")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                        .allowsHitTesting(false)
                                }
                                .background(
                                    Circle()
                                        .fill(Color.blue.opacity(0.7))
                                )
                                .padding(8)
                            }
                        }
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
