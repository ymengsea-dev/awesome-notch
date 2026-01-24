import SwiftUI

struct FileShelf: View {
    @EnvironmentObject var settings: SettingsManager
    var body: some View {
        Form{
            Section {
                // Enable AirDrop toggle
                Toggle("Enable AirDrop", isOn: Binding(
                    get: { settings.isEnableAirDrop },
                    set: { newValue in
                        settings.isEnableAirDrop = newValue
                    }
                ))
            }
            
            Section {
                // Enable open file tab if there items
                VStack{
                    Toggle("Open shelf if there item", isOn: Binding(
                        get: { settings.isOpenFileWhenHasItem },
                        set: { newValue in
                            settings.isOpenFileWhenHasItem = newValue
                        }
                    ))
                    Text("Auto open notch in shelf tab if there any item in shelf")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Section {
                // Enable grab bunch of file button
                VStack{
                    Toggle("Enable grab all button", isOn: Binding(
                        get: { settings.isGrabBunch },
                        set: { newValue in
                            settings.isGrabBunch = newValue
                        }
                    ))
                    Text("Show the button for grab all items in shelf")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .formStyle(.grouped)
    }
}
