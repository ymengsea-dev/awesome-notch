import SwiftUI
import AppKit

struct NotchView<Content: View>: View {
    @ObservedObject private var musicManager = MusicManager.shared
    @State private var expanded = false
    @State private var notchSize: CGSize? = nil
    
    // Dynamic content that can be any SwiftUI view
    let content: Content
    
    // Initializer that accepts any view content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        let collapsedWidth = (notchSize?.width ?? 180) + 100
        let collapsedHeight = (notchSize?.height ?? 32) + 6
        
        return NotchShape(
            topCornerRadius: expanded ? 22 : 12,
            bottomCornerRadius: expanded ? 22 : 12
        )
        .fill(expanded ? .black : (musicManager.isPlaying ? .black : .clear))
        .frame(
            width: expanded ? nil : collapsedWidth,
            height: expanded ? nil : collapsedHeight
        )
        .animation(.bouncy(duration: 0.2), value: collapsedWidth)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay(alignment: .topLeading) {
            // Expanded content
            content
                .padding(.vertical)
                .padding(.horizontal, 35)
                .opacity(expanded ? 1 : 0) // Hide content when collapsed
        }
        .overlay(alignment: .top) {
            // Collapsed content: artwork and spectrum positioned at top of notch
            if !expanded && musicManager.isPlaying {
                HStack{
                    // Artwork on the left
                    Group {
                        if let artwork = musicManager.artwork {
                            Image(nsImage: artwork)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                        } else {
                            Image("apple_music")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                                .animation(.bouncy,value: musicManager.isPlaying)
                        }
                    }
                    .frame(width: 24, height: 24)
                    .cornerRadius(3)
                    .clipped()
                    Spacer()
                    
                    // Audio spectrum on the right
                    AudioSpectrum(isPlaying: musicManager.isPlaying)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .frame(width: collapsedWidth, alignment: .top)
                .transition(.opacity.combined(with: .scale(scale: 0.5)))
                .opacity(expanded ? 0 : 1)
            }
        }
        .animation(.bouncy, value: musicManager.isPlaying)
        .clipShape(NotchShape(
            topCornerRadius: expanded ? 22 : 12,
            bottomCornerRadius: expanded ? 22 : 12
        ))
        .onAppear {
            if let screen = NSScreen.main {
                notchSize = screen.notchSize
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NotchExpanded"))) { notification in
            if let isExpanded = notification.object as? Bool {
                withAnimation(
                    isExpanded ? .bouncy(duration: 0.2): .snappy(duration: 0.2)
                ) {
                    expanded = isExpanded
                }
            }
        }
    }
}

#Preview {
    NotchView {
        // Example content - you can put any view here!
        VStack(spacing: 8) {
            Text("Notch Content")
                .foregroundColor(.white)
                .font(.headline)
            Text("Customize me!")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}
