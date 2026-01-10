import Foundation
import AppKit
import Combine

enum MediaCommand: UInt32 {
    case play = 0
    case pause = 1
    case togglePlayPause = 2
    case nextTrack = 4
    case previousTrack = 5
}

final class MusicManager: ObservableObject {
        
    static let shared = MusicManager()

    @Published var title: String = "Not Playing"
    @Published var artist: String = ""
    @Published var artwork: NSImage? = nil
    @Published var bundleID: String = ""
    @Published var isPlaying = false

    private let bundle: CFBundle?

    init() {
        self.bundle = CFBundleCreate(
            kCFAllocatorDefault,
            NSURL(
                fileURLWithPath:
                    "/System/Library/PrivateFrameworks/MediaRemote.framework"
            )
        )
        setupNotifications()
    }
    // listening for change track the audio
    func setupNotifications() {
        let nc = NotificationCenter.default
        // Listen for now playing info changes
        let infoChangeName = NSNotification.Name(
            "kMRMediaRemoteNowPlayingInfoDidChangeNotification"
        )
        nc.addObserver(forName: infoChangeName, object: nil, queue: .main) {
            [weak self] _ in
            self?.fetchNowPlaying()
        }
        // Listen for playback state changes
        let playbackStateName = NSNotification.Name(
            "kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification"
        )
        nc.addObserver(forName: playbackStateName, object: nil, queue: .main) {
            [weak self] _ in
            self?.fetchNowPlaying()
        }
    }

    // control center
    func sendCommand(_ command: MediaCommand) {
        guard let bundle = bundle,
            let pointer = CFBundleGetFunctionPointerForName(
                bundle,
                "MRMediaRemoteSendCommand" as CFString
            )
        else { return }

        // Command signature: (CommandID, OptionsDictionary) -> Bool
        typealias MRMediaRemoteSendCommandFunction =
            @convention(c) (UInt32, AnyObject?) -> Bool
        let MRMediaRemoteSendCommand = unsafeBitCast(
            pointer,
            to: MRMediaRemoteSendCommandFunction.self
        )

        let success = MRMediaRemoteSendCommand(command.rawValue, nil)
        print("Command \(command) sent. Success: \(success)")
    }

    func fetchNowPlaying() {
        guard let bundle = bundle else {
            isPlaying = false
            return
        }

        // 1. Get Function Pointer
        guard
            let getInfoPtr = CFBundleGetFunctionPointerForName(
                bundle,
                "MRMediaRemoteGetNowPlayingInfo" as CFString
            )
        else {
            isPlaying = false
            return
        }

        typealias MRMediaRemoteGetNowPlayingInfoFunction =
            @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) ->
            Void
        let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(
            getInfoPtr,
            to: MRMediaRemoteGetNowPlayingInfoFunction.self
        )

        // 2. Execution
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { [weak self] info in
            guard let self = self else { return }

            // Check if there's actually media playing
            let hasTitle = info["kMRMediaRemoteNowPlayingInfoTitle"] != nil

            if !hasTitle {
                self.isPlaying = false
                self.title = "Not Playing"
                self.artist = ""
                self.artwork = nil
                return
            }

            // Extract Metadata safely
            self.title =
                info["kMRMediaRemoteNowPlayingInfoTitle"] as? String
                ?? "Unknown Title"
            self.artist =
                info["kMRMediaRemoteNowPlayingInfoArtist"] as? String
                ?? "Unknown Artist"

            if let artworkData = info["kMRMediaRemoteNowPlayingInfoArtworkData"]
                as? Data
            {
                self.artwork = NSImage(data: artworkData)
            }

            // Extract Bundle ID (The App playing the music)
            if let clientData = info[
                "kMRMediaRemoteNowPlayingInfoClientPropertiesData"
            ] as? Data {
                self.bundleID = self.extractBundleID(from: clientData)
            }

            // Extract playback state from playback rate
            // Playback rate: 0 = paused, 1 = playing, > 1 = fast forward
            if let playbackRate = info[
                "kMRMediaRemoteNowPlayingInfoPlaybackRate"
            ] as? Double {
                self.isPlaying = playbackRate > 0
            } else if let playbackRate = info[
                "kMRMediaRemoteNowPlayingInfoPlaybackRate"
            ] as? Float {
                self.isPlaying = playbackRate > 0
            } else {
                // If we have media info but no playback rate, assume it's playing
                // (since we only get notifications when something is playing)
                self.isPlaying = true
            }
        }
    }

    private func extractBundleID(from data: Data) -> String {
        guard let bundle = bundle,
            let getBundleIDPtr = CFBundleGetFunctionPointerForName(
                bundle,
                "MRNowPlayingClientGetBundleIdentifier" as CFString
            )
        else { return "" }

        typealias MRNowPlayingClientGetBundleIdentifierFunction =
            @convention(c) (AnyObject?) -> String
        let MRNowPlayingClientGetBundleIdentifier = unsafeBitCast(
            getBundleIDPtr,
            to: MRNowPlayingClientGetBundleIdentifierFunction.self
        )

        let _MRNowPlayingClientProtobuf: AnyClass? = NSClassFromString(
            "_MRNowPlayingClientProtobuf"
        )
        let handle = dlopen("/usr/lib/libobjc.A.dylib", RTLD_NOW)
        defer { dlclose(handle) }

        let msgSend = unsafeBitCast(
            dlsym(handle, "objc_msgSend"),
            to: (@convention(c) (AnyClass?, Selector) -> AnyObject).self
        )
        let msgSendInit = unsafeBitCast(
            dlsym(handle, "objc_msgSend"),
            to: (@convention(c) (AnyObject?, Selector, Data) -> Void).self
        )

        let obj = msgSend(
            _MRNowPlayingClientProtobuf,
            sel_registerName("alloc")
        )
        msgSendInit(obj, sel_registerName("initWithData:"), data)

        return MRNowPlayingClientGetBundleIdentifier(obj)
    }
}
