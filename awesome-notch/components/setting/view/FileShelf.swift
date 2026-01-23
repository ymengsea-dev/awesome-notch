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
                Toggle("Open shelf if there item", isOn: Binding(
                    get: { settings.isOpenFileWhenHasItem },
                    set: { newValue in
                        settings.isOpenFileWhenHasItem = newValue
                    }
                ))
            }
            
            Section {
                // Enable grab bunch of file button
                Toggle("Open shelf if there item", isOn: Binding(
                    get: { settings.isGrabBunch },
                    set: { newValue in
                        settings.isGrabBunch = newValue
                    }
                ))
            }
        }
        .formStyle(.grouped)
    }
}
