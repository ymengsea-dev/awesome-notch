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

    @Published var title: String = "Not Playing"
    @Published var artist: String = ""
    @Published var artwork: NSImage? = nil
    @Published var bundleID: String = ""
    @Published var isPlaying = false

    private let bundle: CFBundle?

    init() {
            self.bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))
            
            // 1. Mandatory: Register for notifications
            registerForNotifications()
            
            // 2. Setup local observers
            setupNotifications()
            
            // 3. Initial fetch
            fetchNowPlaying()
        }
    
    private func registerForNotifications() {
            guard let bundle = bundle,
                  let ptr = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString) else { return }
            
            typealias RegisterFunction = @convention(c) (DispatchQueue) -> Void
            let register = unsafeBitCast(ptr, to: RegisterFunction.self)
            register(DispatchQueue.main)
        }
    
    // listening for change track the audio
    func setupNotifications() {
            let nc = NotificationCenter.default
            let songChange = NSNotification.Name("kMRMediaRemoteNowPlayingInfoDidChangeNotification")
            let stateChange = NSNotification.Name("kMRPlaybackStateDidChangeNotification")

            // Trigger fetch whenever song or play/pause state changes
            nc.addObserver(forName: songChange, object: nil, queue: .main) { [weak self] _ in
                self?.fetchNowPlaying()
            }
            nc.addObserver(forName: stateChange, object: nil, queue: .main) { [weak self] _ in
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
        guard let bundle = bundle,
            let getInfoPtr = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString) else { return }

            typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
            let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(getInfoPtr, to: MRMediaRemoteGetNowPlayingInfoFunction.self)

            MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { [weak self] info in
                guard let self = self else { return }
                
                // Sync UI instantly
                DispatchQueue.main.async {
                    self.artwork = nil
                    self.title = info["kMRMediaRemoteNowPlayingInfoTitle"] as? String ?? "Unknown Title"
                    self.artist = info["kMRMediaRemoteNowPlayingInfoArtist"] as? String ?? "Unknown Artist"
                    
                    // Track playing state (Rate 1.0 = playing, 0.0 = paused)
                    if let rate = info["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Double {
                        self.isPlaying = (rate > 0)
                    }

                    if let artworkData = info["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
                        self.artwork = NSImage(data: artworkData)
                    }
                }
            }
            
            // 2. Execution
            MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { [weak self] info in
                guard let self = self else { return }
                
                // Extract Metadata safely
                self.title = info["kMRMediaRemoteNowPlayingInfoTitle"] as? String ?? "Unknown Title"
                self.artist = info["kMRMediaRemoteNowPlayingInfoArtist"] as? String ?? "Unknown Artist"
                
                if let artworkData = info["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
                    self.artwork = NSImage(data: artworkData)
                }
                
                // Extract Bundle ID (The App playing the music)
                if let clientData = info["kMRMediaRemoteNowPlayingInfoClientPropertiesData"] as? Data {
                    self.bundleID = self.extractBundleID(from: clientData)
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
