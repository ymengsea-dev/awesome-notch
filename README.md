# Awesome Notch

A macOS application that transforms your MacBook's notch into an interactive control center, providing quick access to media controls and system information directly from the top of your screen.

## 📋 Current Status

**Version: 1.1.0** (dev/version1.1.0)

### ✅ Completed Features

- **Music Control Feature** - Fully implemented and functional
  - Real-time music playback information display
  - Play/Pause, Next Track, Previous Track controls
  - artwork display
  - Audio spectrum visualization
  - Integration with macOS MediaRemote framework
  - Support for all major music apps (Apple Music, Spotify, etc.)

### 🚧 Upcoming Features

- File management view (placeholder implemented)
- Settings panel (basic structure in place)

## 🎯 Features

### Music Control (v1.1.0)

The notch interface provides a seamless music control experience:

- **Collapsed State**: 
  - Shows album artwork thumbnail and animated audio spectrum when music is playing
  - Minimal, unobtrusive design that blends with the notch
  
- **Expanded State**:
  - Full music player interface with:
    - Large album artwork (70x70px)
    - Song title and artist information
    - Play/Pause, Next, and Previous track controls
    - Real-time playback state synchronization

- **Smart Interaction**:
  - Hover to expand the notch interface
  - Auto-collapse when mouse leaves the area
  - Smooth animations and transitions
  - Works across all Spaces and full-screen apps

## 🏗️ Project Structure

```
awesome-notch/
├── awesome-notch/
│   ├── awesome_notchApp.swift          # Main app entry point
│   ├── ContentView.swift                # Main content view
│   │
│   ├── components/
│   │   ├── notch/
│   │   │   ├── NotchWindowController.swift  # Window management & animations
│   │   │   ├── NotchView.swift             # Main notch UI component
│   │   │   └── NotchShape.swift            # Custom notch shape drawing
│   │   │
│   │   └── mediaContol/
│   │       ├── MusicManager.swift          # MediaRemote integration & state
│   │       ├── AudioSpectrum.swift         # Audio visualization component
│   │       └── PlayingBars.swift           # Alternative playing indicator
│   │
│   ├── view/
│   │   ├── NotchTabs.swift                 # Tab navigation (Home/File)
│   │   ├── HomeView.swift                  # Music control interface
│   │   ├── FileView.swift                  # File view (placeholder)
│   │   └── SettingsView.swift              # Settings panel (placeholder)
│   │
│   └── utils/
│       ├── GetNotchDimension.swift         # Notch size detection
│       └── TrackingView.swift              # Mouse tracking utilities
│
└── awesome-notch.xcodeproj/                # Xcode project files
```

## 🔧 Technical Details

### Architecture

- **SwiftUI** for UI components
- **AppKit** for window management and system integration
- **MediaRemote Framework** (private) for music control
- **Combine** for reactive state management

### Key Components

1. **NotchWindowController**: 
   - Manages the floating window that displays the notch interface
   - Handles expansion/collapse animations
   - Manages mouse tracking and hover detection
   - Works across multiple Spaces and full-screen apps

2. **MusicManager**:
   - Singleton that manages music playback state
   - Integrates with macOS MediaRemote framework
   - Provides real-time updates for:
     - Current track information (title, artist)
     - Album artwork
     - Playback state (playing/paused)
     - Bundle ID of the active music app

3. **NotchView**:
   - Main UI component that adapts between collapsed and expanded states
   - Displays different content based on expansion state
   - Handles smooth transitions and animations

## 📦 Requirements

- **macOS**: 12.0 (Monterey) or later
- **Xcode**: 14.0 or later
- **Swift**: 5.7 or later
- **Hardware**: MacBook with notch (MacBook Pro 14" or 16" 2021+)

## 🚀 Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd awesome-notch
```

2. Open the project in Xcode:
```bash
open awesome-notch.xcodeproj
```

3. Build and run the project (⌘R)

4. The app will automatically display the notch interface at the top of your screen

## 💻 Usage

### Basic Usage

1. **Launch the app**: The notch interface appears automatically at the top center of your screen
2. **Hover over the notch**: Move your mouse to the notch area to expand the interface
3. **Control music**: Use the expanded interface to control your music playback
4. **Auto-collapse**: The interface automatically collapses when you move your mouse away

### Music Controls

- **Play/Pause**: Click the play/pause button in the expanded view
- **Next Track**: Click the forward button
- **Previous Track**: Click the backward button
- **View Info**: See current track title, artist, and artwork in the expanded view

### Settings

Access settings by clicking the gear icon in the expanded notch interface. (Settings panel is currently a placeholder for future implementation)

## 🔮 Future Features

The following features are planned for future releases:

- **File Management**: Quick file access and management from the notch
- **Mirror Camera**: Open webcam for preview before you video call
- **Unknow**: Comming soon!

## 🛠️ Development

### Current Branch

- **dev/version1.1.0**: Music control feature implementation

### Building from Source

1. Ensure you have Xcode installed
2. Open `awesome-notch.xcodeproj`
3. Select your target Mac as the build destination
4. Build and run (⌘R)

### Code Style

- Follow SwiftUI best practices
- Use `@Published` properties for reactive state
- Keep components modular and reusable
- Document complex logic and private framework usage

## 📝 Notes

- The app uses private macOS frameworks (MediaRemote) for music control functionality
- The notch interface is designed to work seamlessly with macOS Spaces and full-screen apps
- Window level is set to `.statusBar` to ensure it stays above other windows
- Mouse tracking is optimized to prevent flickering during animations

## 🤝 Contributing

This project is in active development. New features and improvements are welcome!


## 👤 Author

Created by **Y MENGSEA**

---

**Version 1.1.0** - Music Control Feature Release
