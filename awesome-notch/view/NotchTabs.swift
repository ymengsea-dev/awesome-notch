import SwiftUI

enum Tab {
    case home
    case file
    case webcame
}

struct NotchTabs: View {
    @ObservedObject var tabManager = TabManager.share
    @ObservedObject private var settings = SettingsManager()
    
    var body: some View {
        NavigationStack{
            HStack{
                HStack{
                    // home tab
                    Button{
                        tabManager.selectedTab = Tab.home
                    }label: {
                        Image(systemName: "house.fill")
                            .foregroundStyle(.white)
                            .frame(width: 35, height: 20)
                            .background(
                                tabManager.selectedTab == .home ? .gray.opacity(0.5) : .clear
                            )
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                    // file tab
                    Button{
                        tabManager.selectedTab = Tab.file
                    }label: {
                        Image(systemName: "tray.fill")
                            .foregroundStyle(.white)
                            .frame(width: 35, height: 20)
                            .background(tabManager.selectedTab == .file ? .gray.opacity(0.5) : .clear)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                HStack{
                    // seperate webcame tab
                    if settings.isEnableWebcameTab{
                        Button{
                            tabManager.selectedTab = Tab.webcame
                        }label: {
                            Image(systemName: "web.camera")
                                .foregroundStyle(.white)
                                .frame(width: 35, height: 20)
                                .background(
                                    tabManager.selectedTab == .webcame ? .gray
                                        .opacity(0.5) : .clear
                                )
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // settings button
                    Button{
                        NotchWindowController.shared.showSettingsWindow()
                    }label: {
                        Image(systemName: "gear")
                            .foregroundStyle(.white)
                            .frame(width: 35, height: 20)
                    }
                    .buttonStyle(.plain)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .topTrailing
                )
            }
            VStack{
                switch tabManager.selectedTab {
                case .home:
                    HomeView()
                case .file:
                    FileView()
                case .webcame:
                    WebcameView()
                }
            }.padding(.top, 10)
            
        }
    }
}

#Preview {
    NotchTabs()
}

