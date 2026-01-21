import SwiftUI
import Combine

class SettingsManager: ObservableObject{
    //---- general settings -----
    
    @AppStorage("notchSize") var notchSizeRaw = NotchSize.small.rawValue
    var notchSize: NotchSize {
        get { NotchSize(rawValue: notchSizeRaw) ?? .small }
        set { notchSizeRaw = newValue.rawValue }
    }
    
    @AppStorage("notchColor") var notchColorName = "blue"
    var notchColor: Color {
        switch notchColorName {
        case "black": return .black
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "orange": return .orange
        case "pink": return .pink
        case "yellow": return .yellow
        case "cyan": return .cyan
        case "indigo": return .indigo
        case "mint": return .mint
        case "teal": return .teal
        default: return .black
        }
    }
    static let availableColors: [(name: String, color: Color)] = [
        ("black", .black),
        ("blue", .blue),
        ("red", .red),
        ("green", .green),
        ("purple", .purple),
        ("orange", .orange),
        ("pink", .pink),
        ("yellow", .yellow),
        ("cyan", .cyan),
        ("indigo", .indigo),
        ("mint", .mint),
        ("teal", .teal)
    ]
    
    @AppStorage("expandSensitivity") var expandSensitivityRaw: String = "100ms"
    var expandSensitivity: Double {
        get {
            // Convert from "100ms" format to seconds (0.1)
            let msValue = expandSensitivityRaw.replacingOccurrences(of: "ms", with: "")
            return (Double(msValue) ?? 100.0) / 1000.0
        }
        set {
            // Convert from seconds to "100ms" format
            expandSensitivityRaw = "\(Int(newValue * 1000))ms"
        }
    }
    
    static let availableSensitivities: [(label: String, value: String, delay: Double)] = [
        ("Fast", "100ms", 0.1),
        ("Medium", "200ms", 0.2),
        ("Slow", "500ms", 0.5),
    ]
    
    @AppStorage("isLaunchAtLogin") var isLaunchAtLogin = false{
        didSet{
            // when the setting change update the system
            LaunchManager.shared.setLaunchAtLogin(isLaunchAtLogin)
        }
    }
    // sync with the system
    func syncWithSystem(){
        let systemStatus =  LaunchManager.shared.isEnabled
        if isLaunchAtLogin != systemStatus{
            self.isLaunchAtLogin = systemStatus
        }
    }
    
    @AppStorage("isEnableAirDrop") var isEnableAirDrop = true
    @AppStorage("isSyncWithMission") var isSyncWithMission = false
}
