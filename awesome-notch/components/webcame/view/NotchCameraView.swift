import SwiftUI
import AVFoundation

struct NotchCameraView: View {
    @StateObject var camera = CameraManager()
    @State private var isCameraRunning = false
    
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.7))
                .overlay(
                    // Show the camera only if isCameraRunning is true
                    Group {
                        if isCameraRunning {
                            CameraPreview(session: camera.session)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            // Icon to show it's clickable
                            Image(systemName: "camera.fill")
                                .foregroundColor(.gray)
                        }
                    }
                )
                .frame(width: 75, height: 75)
                .shadow(radius: 5)
                .onTapGesture {
                    toggleCamera()
                }
        }
    }

    func toggleCamera() {
        if isCameraRunning {
            camera.session.stopRunning()
            isCameraRunning = false
        } else {
            isCameraRunning = true
            // Important: checkPermissions handles setup AND startRunning
            camera.checkPermissions()
        }
    }
}
