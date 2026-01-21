import ServiceManagement

class LaunchManager {
    static let shared = LaunchManager()
    
    var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }
    
    func setLaunchAtLogin(_ enabled: Bool) {
        guard enabled != isEnabled else { return }

        do {
            if enabled {
                try SMAppService.mainApp.register()
                print("Successfully registered for login")
            } else {
                try SMAppService.mainApp.unregister()
                print("Successfully unregistered from login")
            }
        } catch {
            // Important: This usually fails if the app is not in /Applications
            print("Failed to update Launch at Login: \(error)")
        }
    }
}
