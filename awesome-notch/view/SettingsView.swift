import SwiftUI

struct SettingsView: View {
    
    @State private var selection: SidebarItems? = .general
    
    var body: some View {
        NavigationSplitView {
            List(SidebarItems.allCases, selection: $selection) { item in
                NavigationLink(value: item) {
                    Label(item.title, systemImage: item.icon)
                }
            }
            .listStyle(.sidebar)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            switch selection {
            case .general:
                General()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .media:
                MusicControl()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .shelf:
                FileShelf()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .webcame:
                Webcame()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .appearance:
                Appearance()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .about:
                About()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .none:
                EmptyView()
            }
        }
        .frame(minWidth: 700, minHeight: 500)
    }
}

enum SidebarItems: String, CaseIterable, Identifiable{
    case general
    case media
    case shelf
    case webcame
    case appearance
    case about
    
    var id: String {rawValue}
    
    var title: String{
        rawValue.capitalized
    }
    
    var icon: String{
        switch self {
        case .general: return "gear"
        case .media: return "music.note"
        case .shelf: return "tray.fill"
        case .webcame: return "web.camera"
        case .appearance: return "eye"
        case .about: return "exclamationmark.circle"
        }
    }
}

