import SwiftUI

struct MusicControl: View {
    @EnvironmentObject var settings: SettingsManager
    var body: some View {
        Form{
            // spectrum color
            Section{
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
            }
            
            // border notch
            Section{
                VStack{
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
            // extend side noth when playing
            Section{
                Toggle("Extend notch when playing", isOn: Binding(
                    get: { settings.isOverflowNotchWhenPlaying},
                    set: { newValue in
                        settings.isOverflowNotchWhenPlaying = newValue
                    }))
            }
        }
        .formStyle(.grouped)
    }
}


