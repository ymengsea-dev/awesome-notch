//
//  awesome_notchApp.swift
//  awesome-notch
//
//  Created by MacBook on 1/8/26.
//

import SwiftUI

@main
struct awesome_notchApp: App {
    init() {
            DispatchQueue.main.async {
                NotchWindowController.shared.show()
            }
        }
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
