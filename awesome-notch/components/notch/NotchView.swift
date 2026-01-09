import SwiftUI
import AppKit

struct NotchView<Content: View>: View {
    @State private var expanded = false
    @State private var notchSize: CGSize? = nil
    
    // Dynamic content that can be any SwiftUI view
    let content: Content
    
    // Initializer that accepts any view content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        NotchShape(
            topCornerRadius: expanded ? 22 : 12,
            bottomCornerRadius: expanded ? 22 : 12
        )
        .fill(expanded ? .black : .clear)
        .frame(
            width: expanded ? nil : (notchSize?.width ?? 180),
            height: expanded ? nil : (notchSize?.height ?? 32)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay(alignment: .topLeading) {
            // custom content appears here
            content
                .padding(.vertical)
                .padding(.horizontal, 30)
                .opacity(expanded ? 1 : 0) // Hide content when collapsed
        }
        .onAppear {
            if let screen = NSScreen.main {
                notchSize = screen.notchSize
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NotchExpanded"))) { notification in
            if let isExpanded = notification.object as? Bool {
                withAnimation(.bouncy(duration: 0.3)) {
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
