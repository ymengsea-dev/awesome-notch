import SwiftUI
import AppKit

struct NotchView: View {
    @State private var expanded = false
    @State private var notchSize: CGSize? = nil

    var body: some View {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: expanded ? 22 : 12,
            bottomTrailingRadius: expanded ? 22 : 12,
            topTrailingRadius: 0
        )
        .fill( expanded ? .black : .clear)
        .frame(
            width: expanded ? nil : (notchSize?.width ?? 180),
            height: expanded ? nil : (notchSize?.height ?? 32)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            if let screen = NSScreen.main {
                notchSize = screen.notchSize
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NotchExpanded"))) { notification in
            if let isExpanded = notification.object as? Bool {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expanded = isExpanded
                }
            }
        }
    }
}

