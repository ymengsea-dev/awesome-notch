import SwiftUI
import Combine

class SettingsManager: ObservableObject{
    
    //---- general settings -----
    @AppStorage("notchSize") var notchSizeRaw = NotchSize.small.rawValue
    var notchSize: NotchSize {
        get { NotchSize(rawValue: notchSizeRaw) ?? .small }
        set { notchSizeRaw = newValue.rawValue }
    }
    
    @AppStorage("notchColor") var notchColorName = "black"
    var notchColor: Color {
        switch notchColorName {
        case "black": return .black
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
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
    
    // ----- media setting -----
    @AppStorage("colorSpectrum") var colorSpectrumName = "white" // color spectrum
    var colorSpectrum: AnyShapeStyle {
        switch colorSpectrumName {
        case "neon-fire":
                return AnyShapeStyle(LinearGradient(
                    colors: [.orange, .red, .pink],
                    startPoint: .bottom,
                    endPoint: .top
                ))
            case "ocean-depth":
                return AnyShapeStyle(LinearGradient(
                    colors: [.blue, .cyan],
                    startPoint: .bottom,
                    endPoint: .top
                ))
            case "purple-haze":
                return AnyShapeStyle(LinearGradient(
                    colors: [.purple, .indigo],
                    startPoint: .bottom,
                    endPoint: .top
                ))
        case "white": return AnyShapeStyle(Color.white)
        case "black": return AnyShapeStyle(Color.black)
        case "blue": return AnyShapeStyle(Color.blue)
        case "red": return AnyShapeStyle(Color.red)
        case "green": return AnyShapeStyle(Color.green)
        case "purple": return AnyShapeStyle(Color.purple)
        case "orange": return AnyShapeStyle(Color.orange)
        case "pink": return AnyShapeStyle(Color.pink)
        case "yellow": return AnyShapeStyle(Color.yellow)
        case "cyan": return AnyShapeStyle(Color.cyan)
        case "indigo": return AnyShapeStyle(Color.indigo)
        case "mint": return AnyShapeStyle(Color.mint)
        case "teal": return AnyShapeStyle(Color.teal)
        default: return AnyShapeStyle(Color.white)
        }
    }
    
    static let availableSpectrumColors: [(name: String, color: AnyShapeStyle)] = [
        ("neon-fire", AnyShapeStyle(LinearGradient(colors: [.orange, .red, .pink],startPoint: .bottom,endPoint: .top))),
        ("ocean-depth", AnyShapeStyle(LinearGradient(colors: [.blue, .cyan],startPoint: .bottom,endPoint: .top))),
        ("purple-haze", AnyShapeStyle(LinearGradient(colors: [.purple, .indigo],startPoint: .bottom, endPoint: .top))),
        ("white", AnyShapeStyle(Color.white)),
        ("black", AnyShapeStyle(Color.black)),
        ("blue", AnyShapeStyle(Color.blue)),
        ("red", AnyShapeStyle(Color.red)),
        ("green", AnyShapeStyle(Color.green)),
        ("purple", AnyShapeStyle(Color.purple)),
        ("orange", AnyShapeStyle(Color.orange)),
        ("pink", AnyShapeStyle(Color.pink)),
        ("yellow", AnyShapeStyle(Color.yellow)),
        ("cyan", AnyShapeStyle(Color.cyan)),
        ("indigo", AnyShapeStyle(Color.indigo)),
        ("mint", AnyShapeStyle(Color.mint)),
        ("teal", AnyShapeStyle(Color.teal))
    ]
    
    @AppStorage("notchBorder") var isNotchBorder = false // border around notch
    @AppStorage("NotchBorderColor") var notchBorderColorName = "pink"
    var NotchBorderColor: Color {
        switch notchBorderColorName {
        case "black": return .black
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "pink": return .pink
        case "yellow": return .yellow
        case "cyan": return .cyan
        case "indigo": return .indigo
        case "mint": return .mint
        case "teal": return .teal
        default: return .pink
        }
    }
    static let availableNotchBorderColors: [(name: String, color: Color)] = [
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
    @AppStorage("overflowNotchWhenPlaying") var isOverflowNotchWhenPlaying = true  // extend side noth when playing
    
    
    // ----- shelf setting -----
    @AppStorage("isOpenFileWhenHasItem") var isOpenFileWhenHasItem = true
    @AppStorage("isGrabBunch") var isGrabBunch = true
    
    // ---- webcame setting ----
    @AppStorage("isEnableWebcame") var isEnableWebcame = true // enable webcame in home tab
    @AppStorage(
        "webcameShape"
    ) var webcameShapeRaw: String = WebcameShape.roundedRectangle.rawValue  // webcame shape
    var webcameShape: WebcameShape {
        get { WebcameShape(rawValue: webcameShapeRaw) ?? .roundedRectangle }
        set { webcameShapeRaw = newValue.rawValue }
    }
    @AppStorage("isKeepNotchExtendedWhenCameraOn") var isKeepNotchExtendedWhenCameraOn = false // keep notch extended when camera is on
    @AppStorage("isEnableWebcameTab") var isEnableWebcameTab = false // seperate webcame another tab
    
}
