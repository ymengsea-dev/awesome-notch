import Foundation
import MediaPlayer
import AppKit
import Combine

@MainActor
final class MusicManager: ObservableObject {
    static let shared = MusicManager()

        @Published var title = ""
        @Published var artist = ""
        @Published var artwork: NSImage?
        @Published var isPlaying = false

        private var observers: [NSObjectProtocol] = []

        private init() {
            startObserving()
        }

        private func startObserving() {
            let center = DistributedNotificationCenter.default()

            observers.append(
                center.addObserver(
                    forName: Notification.Name("com.apple.music.playerInfo"),
                    object: nil,
                    queue: .main
                ) { [weak self] notification in
                    self?.handle(notification)
                }
            )

            observers.append(
                center.addObserver(
                    forName: Notification.Name("com.apple.iTunes.playerInfo"),
                    object: nil,
                    queue: .main
                ) { [weak self] notification in
                    self?.handle(notification)
                }
            )
        }

        private func handle(_ notification: Notification) {
            guard let info = notification.userInfo else { return }

            title = info["Name"] as? String ?? ""
            artist = info["Artist"] as? String ?? ""

            if let state = info["Player State"] as? String {
                isPlaying = (state == "Playing")
            }

            if let data = info["Artwork"] as? Data {
                artwork = NSImage(data: data)
            }
        }
}

