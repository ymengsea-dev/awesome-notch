import SwiftUI

struct FileView: View {
    let spacing: CGFloat = 10
    
    var body: some View {
        GeometryReader { geo in
            let availableWidth = geo.size.width - spacing

            HStack(spacing: spacing) {
                AirDropZoneView()
                    .frame(width: availableWidth * 1 / 4)

                NotchShelfView()
                    .frame(width: availableWidth * 3 / 4)
                    
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FileView()
}
