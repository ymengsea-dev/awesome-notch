import SwiftUI
import UniformTypeIdentifiers

struct AirDropZoneView: View {
    
    @StateObject var airDropManager = AirDropManager.shared
    @State private var isTargeted = false

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.system(size: 24))
            Text("AirDrop")
                .fontWeight(.bold)
        }
        .foregroundStyle(isTargeted ? .blue : .gray)
        .padding(.horizontal, 30)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.001))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(style: StrokeStyle(
                    lineWidth: 3,
                    dash: [10,5]
                ))
                .foregroundStyle(isTargeted ? .blue : .gray)
        }
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
            airDropManager.handleAirDrop(providers: providers)
            return true
        }
    }
}
