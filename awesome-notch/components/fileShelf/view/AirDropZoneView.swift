import SwiftUI
import UniformTypeIdentifiers

struct AirDropZoneView: View {
    
    @ObservedObject var airDropManager = AirDropManager.shared
    @State private var isTargeted = false

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: "airplay.audio")
                .font(.title3)
                .foregroundStyle(.gray)
            Text("AirDrop")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(isTargeted ? .blue : .gray)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(isTargeted ? 0.6 : 0.4))
        }
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
            airDropManager.handleAirDrop(providers: providers)
            return true
        }
    }
}
