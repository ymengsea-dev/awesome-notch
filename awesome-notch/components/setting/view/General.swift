import SwiftUI

struct General: View {
    @EnvironmentObject var settings: SettingsManager
    
    var body: some View {
        Form {
            Section {
                // 1. Notch size slider
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Notch Size")
                        Spacer()
                        Text(settings.notchSize.title)
                            .foregroundColor(.secondary)
                    }
                    Slider(
                        value: Binding(get: {
                            Double(NotchSize.allCases.firstIndex(of: settings.notchSize) ?? 0)
                        }, set: { newValue in
                            let index = Int(round(newValue))
                            if index >= 0 && index < NotchSize.allCases.count {
                                settings.notchSize = NotchSize.allCases[index]
                            }
                        }),
                        in: 0...Double(NotchSize.allCases.count - 1),
                        step: 1
                    )
                }
            }
            
            Section {
                // 2. Notch color picker
                Picker("Notch Color", selection: Binding(
                    get: { settings.notchColorName },
                    set: { newValue in
                        settings.notchColorName = newValue
                    }
                )) {
                    ForEach(SettingsManager.availableColors, id: \.name) { colorOption in
                        HStack {
                            Circle()
                                .fill(colorOption.color)
                                .frame(width: 16, height: 16)
                            Text(colorOption.name.capitalized)
                        }
                        .tag(colorOption.name)
                    }
                }
            }
            
            Section {
                // 3. Notch extend sensitivity picker
                VStack{
                    Picker("Extend Sensitivity", selection: Binding(
                        get: { settings.expandSensitivityRaw },
                        set: { newValue in
                            settings.expandSensitivityRaw = newValue
                        }
                    )) {
                        ForEach(SettingsManager.availableSensitivities, id: \.value) { sensitivity in
                            Text(sensitivity.label + " (\(sensitivity.value))")
                                .tag(sensitivity.value)
                        }
                    }
                    Text("Delay before the notch collapses when mouse exits")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Section {
                // 4. Enable AirDrop toggle
                Toggle("Enable AirDrop", isOn: Binding(
                    get: { settings.isEnableAirDrop },
                    set: { newValue in
                        settings.isEnableAirDrop = newValue
                    }
                ))
            }
            
            Section {
                // 5. Launch at login toggle
                Toggle("Launch at login", isOn: $settings.isLaunchAtLogin)
                    .onAppear {
                        settings.syncWithSystem()
                    }
            }
        }
        .formStyle(.grouped)
    }
}
