import SwiftUI

struct Appearance: View {
    @EnvironmentObject var settings: SettingsManager
    
    var body: some View {
        Form {
            // General Appearance Section
            Section("General") {
                // Notch Size
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
                
                // Notch Color
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
            
            // Media Appearance Section
            Section("Media") {
                // Spectrum Color
                Picker(
                    "Spectrum Color",
                    selection: Binding(
                        get: { settings.colorSpectrumName},
                        set: {newValue in
                            settings.colorSpectrumName = newValue
                        }
                    )) {
                        ForEach(
                            SettingsManager.availableSpectrumColors,
                            id: \.name
                        ){ colorOption in
                            HStack{
                                Circle()
                                    .fill(colorOption.color)
                                    .frame(width: 16, height: 16)
                                    Text(colorOption.name.capitalized)
                            }
                            .tag(colorOption.name)
                        }
                    }
                
                // Notch Border
                VStack(alignment: .leading) {
                    Toggle("Notch Border", isOn: Binding(
                        get: { settings.isNotchBorder },
                        set: { newvalue in
                            settings.isNotchBorder = newvalue
                        }
                    ))
                    Text("Enable notch border when playing media")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if settings.isNotchBorder {
                    Picker("Border Color", selection: Binding(
                        get: {settings.notchBorderColorName},
                        set: { newValue in
                            settings.notchBorderColorName = newValue
                        }
                    )){
                        ForEach(
                            SettingsManager.availableNotchBorderColors,
                            id: \.name
                        ){colorOption in
                            HStack{
                                Circle()
                                    .fill(colorOption.color)
                                    .frame(width: 16, height: 16)
                                Text(colorOption.name.capitalized)
                            }
                            .tag(colorOption.name)
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
    }
}
