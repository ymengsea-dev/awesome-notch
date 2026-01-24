import SwiftUI
import AVFoundation

struct NotchCameraView: View {
    @StateObject var camera = CameraManager()
    @State private var isCameraRunning = false
    @EnvironmentObject var settings: SettingsManager
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Group {
                switch settings.webcameShape {
                case .roundedRectangle:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.7))
                        .overlay(
                            Group {
                                if isCameraRunning {
                                    CameraPreview(session: camera.session)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                } else {
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                case .circle:
                    Circle()
                        .fill(.gray.opacity(0.7))
                        .overlay(
                            Group {
                                if isCameraRunning {
                                    CameraPreview(session: camera.session)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                case .rectangle:
                    Rectangle()
                        .fill(.gray.opacity(0.7))
                        .overlay(
                            Group {
                                if isCameraRunning {
                                    CameraPreview(session: camera.session)
                                        .clipShape(Rectangle())
                                } else {
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                }
            }
            .frame(width: 75, height: 75)
            .shadow(radius: 5)
            .onTapGesture {
                toggleCamera()
            }
        }
        .onDisappear {
            stopCamera()
        }
    }

    func toggleCamera() {
        if isCameraRunning {
            camera.stopSession()
            isCameraRunning = false
            NotificationCenter.default.post(name: NSNotification.Name("CameraStateChanged"), object: false)
        } else {
            isCameraRunning = true
            // Important: checkPermissions handles setup AND startRunning
            camera.checkPermissions()
            NotificationCenter.default.post(name: NSNotification.Name("CameraStateChanged"), object: true)
        }
    }
    
    func stopCamera() {
        if isCameraRunning {
            camera.stopSession()
            isCameraRunning = false
            NotificationCenter.default.post(name: NSNotification.Name("CameraStateChanged"), object: false)
        }
    }
}
