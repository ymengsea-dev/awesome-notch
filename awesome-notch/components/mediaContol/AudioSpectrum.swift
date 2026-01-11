import SwiftUI

struct AudioSpectrum: View {
    let isPlaying: Bool
    @State private var barHeights: [CGFloat] = []
    @State private var timer: Timer?
    
    private let barCount = 4
    private let minHeight: CGFloat = 2
    private let maxHeight: CGFloat = 16
    
    var body: some View {
        HStack(spacing: 2.5) {
            ForEach(0..<barCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(.white)
                    .frame(
                        width: 2.5,
                        height: isPlaying ? barHeights[safe: index] ?? minHeight : minHeight
                    )
            }
        }
        .frame(height: maxHeight)
        .onAppear {
            initializeBars()
            if isPlaying {
                startAnimation()
            }
        }
        .onChange(of: isPlaying) { newValue in
            if newValue {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    private func initializeBars() {
        barHeights = Array(repeating: minHeight, count: barCount)
    }
    
    private func startAnimation() {
        stopAnimation() // Clean up any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateBarHeights()
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
        withAnimation(.easeOut(duration: 0.2)) {
            barHeights = Array(repeating: minHeight, count: barCount)
        }
    }
    
    private func updateBarHeights() {
        guard isPlaying else {
            stopAnimation()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.1)) {
            barHeights = (0..<barCount).map { index in
                // Create a more realistic spectrum pattern
                // Lower frequencies (left) tend to be higher, higher frequencies (right) vary more
                let baseHeight: CGFloat
                if index < 2 {
                    baseHeight = CGFloat.random(in: maxHeight * 0.6...maxHeight)
                } else {
                    baseHeight = CGFloat.random(in: maxHeight * 0.3...maxHeight * 0.8)
                }
                return max(minHeight, min(maxHeight, baseHeight))
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
