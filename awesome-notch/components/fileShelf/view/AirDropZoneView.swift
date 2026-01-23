import SwiftUI
import UniformTypeIdentifiers

struct AirDropZoneView: View {
    
    @ObservedObject var airDropManager = AirDropManager.shared
    @State private var isTargeted = false

    var body: some View {
        VStack(spacing: 5) {
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(isTargeted ? 0.6 : 0.4))
                VStack{
                    Image(systemName: "airplay.audio")
                        .font(.title3)
                        .foregroundStyle(.white)
                    Text("AirDrop")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(isTargeted ? .blue : .gray)
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
            airDropManager.handleAirDrop(providers: providers)
            return true
        }
    }
}
