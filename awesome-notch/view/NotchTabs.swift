import SwiftUI

enum Tab {
    case home
    case file
}

struct NotchTabs: View {
    @State private var selectedTab: Tab = .home
    var body: some View {
        NavigationStack{
            HStack{
                HStack{
                    // home tab
                    Button{
                        selectedTab = Tab.home
                    }label: {
                        Image(systemName: "house.fill")
                            .foregroundStyle(.white)
                            .frame(width: 35, height: 20)
                            .background(
                                selectedTab == .home ? .gray.opacity(0.5) : .clear
                            )
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                    // file tab
                    Button{
                        selectedTab = Tab.file
                    }label: {
                        Image(systemName: "tray")
                            .foregroundStyle(.white)
                            .frame(width: 35, height: 20)
                            .background(selectedTab == .file ? .gray.opacity(0.5) : .clear)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                HStack{
                    // home tab
                    Button{
                        NotchWindowController().showSettingsWindow()
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
                switch selectedTab {
                case .home:
                    HomeView()
                case .file:
                    FileView()
                }
            }.padding(.top, 10)
            
        }
    }
}

#Preview {
    NotchTabs()
}

