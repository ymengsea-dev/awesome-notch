//
//  awesome_notchApp.swift
//  awesome-notch
//
//  Created by MacBook on 1/8/26.
//

import SwiftUI
import Sparkle

@main
struct awesome_notchApp: App {
    init() {
        _ = UpdateManager.shared

        DispatchQueue.main.async {
            NotchWindowController.shared.show()
        }
    }
    
    var body: some Scene {
        Settings {
            About()
        }
    }
}
