import Foundation
import Sparkle
import Combine

class UpdateManager: ObservableObject{
    static let shared = UpdateManager()
    
    let updaterController: SPUStandardUpdaterController
    
    init(){
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
    }
    
    func checkForUpdates(){
        updaterController.checkForUpdates(nil)
    }
}
