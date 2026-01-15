import SwiftUI
import UniformTypeIdentifiers

struct AirDropZoneView: View {
    
    @StateObject var airDropManager =  AirDropManager.shared
    @State private var isTargeted = false

    
    var body: some View {
        VStack{
            Image(systemName: "airplayaudio")
                .font(.title3)
                .foregroundStyle(.gray)
            Text("air drop")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 14)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(style: StrokeStyle(
                    lineWidth: 3,
                    dash: [10,5]
                ))
                .foregroundStyle(isTargeted ? .blue : .gray)
        }
        .onDrop(of: [.fileURL], isTargeted: $isTargeted){ providers in
            airDropManager.handleAirDrop(providers: providers)
            return true
        }
    }
}
