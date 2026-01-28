import SwiftUI

struct Webcame: View {
    @EnvironmentObject var settings: SettingsManager
    
    var body: some View {
        Form {
            // enable webcame in home tab
            Section {
                VStack {
                    Toggle("Enable Webcam", isOn: Binding(
                        get: { settings.isEnableWebcame },
                        set: { newValue in
                            settings.isEnableWebcame = newValue
                        }
                    ))
                    Text("Show webcam in home tab")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            // webcame shape
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Webcam Shape")
                        Spacer()
                        Text(settings.webcameShape.title)
                            .foregroundColor(.secondary)
                    }
                    Picker("", selection: Binding(
                        get: { settings.webcameShape },
                        set: { newValue in
                            // Avoid "Publishing changes from within view updates..."
                            // by deferring the AppStorage write to the next run loop.
                            DispatchQueue.main.async {
                                settings.webcameShape = newValue
                            }
                        }
                    )) {
                        ForEach(WebcameShape.allCases, id: \.self) { shape in
                            Text(shape.title).tag(shape)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            
            // notch collape when open webcame
            Section {
                VStack {
                    Toggle("Keep Notch Extended When Camera On", isOn: Binding(
                        get: { settings.isKeepNotchExtendedWhenCameraOn },
                        set: { newValue in
                            settings.isKeepNotchExtendedWhenCameraOn = newValue
                        }
                    ))
                    Text("Keep the notch extended when the webcam is active")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            // seperate webcame another tab
            Section {
                VStack {
                    Toggle("Separate Webcam Tab", isOn: Binding(
                        get: { settings.isEnableWebcameTab },
                        set: { newValue in
                            settings.isEnableWebcameTab = newValue
                        }
                    ))
                    Text("Show webcam in a separate tab")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .formStyle(.grouped)
    }
}
