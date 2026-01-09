import SwiftUI

struct PlayingBars: View {
    let isPlaying: Bool
    @State private var animate = false

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { _ in
                Capsule()
                    .frame(
                        width: 2,
                        height: isPlaying && animate ? 14 : 6
                    )
            }
        }
        .foregroundColor(.white)
        .onAppear {
            if isPlaying {
                withAnimation(
                    .easeInOut(duration: 0.35)
                        .repeatForever(autoreverses: true)
                ) {
                    animate.toggle()
                }
            }
        }
    }
}
