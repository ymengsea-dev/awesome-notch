import SwiftUI

struct FileView: View {
    let spacing: CGFloat = 10
    @ObservedObject private var settings = SettingsManager()
    
    var body: some View {
        GeometryReader { geo in
            let availableWidth = geo.size.width - spacing

            if settings.isEnableAirDrop {
                HStack(spacing: spacing) {
                    AirDropZoneView()
                        .frame(width: availableWidth * 1 / 4)
                    
                    NotchShelfView()
                        .frame(width: availableWidth * 3 / 4)
                    
                }
            }else {
                HStack(spacing: spacing) {
                    NotchShelfView()
                        .frame(width: availableWidth)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FileView()
}
