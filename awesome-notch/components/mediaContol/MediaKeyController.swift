import AppKit

enum MediaKey {
    case playPause
    case next
    case previous
}

enum MediaKeyController {

    nonisolated static func send(_ key: MediaKey) {
        let code: Int32

        switch key {
        case .playPause: code = NX_KEYTYPE_PLAY
        case .next:      code = NX_KEYTYPE_NEXT
        case .previous:  code = NX_KEYTYPE_PREVIOUS
        }

        post(code, down: true)
        post(code, down: false)
    }

    private nonisolated static func post(_ code: Int32, down: Bool) {
        let flags = NSEvent.ModifierFlags(rawValue: down ? 0xA00 : 0xB00)
        let data = Int((code << 16) | (down ? 0xA : 0xB))

        guard let event = NSEvent.otherEvent(
            with: .systemDefined,
            location: .zero,
            modifierFlags: flags,
            timestamp: ProcessInfo.processInfo.systemUptime,
            windowNumber: 0,
            context: nil,
            subtype: 8,
            data1: data,
            data2: -1
        ) else { return }

        event.cgEvent?.post(tap: .cghidEventTap)
    }
}
