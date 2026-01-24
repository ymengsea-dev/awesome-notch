# Awesome Notch

A macOS application that transforms your MacBook's notch into an interactive control center, providing quick access to media controls and system information directly from the top of your screen.

## 📥 Downloads

### ⚠️ Important Note

We don't have an Apple Developer account yet. The application will show a popup on first launch stating that the app is from an **unidentified developer**.

To open the app:

1. Click **OK** to close the popup.
2. Open **System Settings → Privacy & Security**.
3. Scroll down and click **Open Anyway** next to the warning about the app.
4. Confirm your choice if prompted.

### Beta Releases

- **[Download version1.5.3 Beta 1](https://github.com/ymengsea-dev/awesome-notch/releases/download/v1.5.3beta1/Awesome.Notch.dmg)**
  - Music Control & File Shelf Features
  - Includes all completed features from version 1.1.1
  - Music control with artwork background overlay
  - File shelf with AirDrop integration
  - Ready to use - just download, mount, and drag to Applications

## 📋 Current Status

**Version: 1.5.3**

### Version Breakdown
- **Infra**: 1
- **Features**: 5
- **Patches**: 3

### ✅ Completed Features (5)

1. **Music Control** - Fully implemented and functional
   - Real-time music playback information display
   - Play/Pause, Next Track, Previous Track controls
   - Artwork display with background overlay
   - Audio spectrum visualization
   - Integration with macOS MediaRemote framework
   - Support for all major music apps (Apple Music, Spotify, etc.)

2. **File Shelf** - Fully implemented and functional
   - Drag and drop files into the shelf for quick access
   - Visual file icons display
   - Drag files out from the shelf
   - Horizontal scrollable view for multiple files

3. **Webcam** - Fully implemented and functional
   - Live webcam preview in the notch
   - Multiple shape options (Rounded Rectangle, Circle, Rectangle)
   - Toggle camera on/off with a tap
   - Option to keep notch expanded while camera is running
   - Separate webcam tab option

4. **Settings** - Fully implemented and functional
   - General settings (notch size, color, expand sensitivity, launch at login)
   - Music control settings (spectrum color, notch border, extend notch when playing)
   - File shelf settings (open file when has item, grab bunch)
   - Webcam settings (enable webcam, shape selection, keep notch extended)

5. **AirDrop** - Fully implemented and functional
   - Dedicated AirDrop zone for quick file sharing
   - Drop files on the AirDrop zone to trigger AirDrop sharing
   - Visual feedback when files are targeted for AirDrop
   - Auto-switch to File tab when dragging files near the notch

### 🔧 Patches (3)

- **Camera bugfix** - Fixed camera session management and state handling
- **Music control bugfix** - Fixed music playback state synchronization
- **File shelf bugfix** - Fixed file drag and drop operations

## 🎯 Features

### Music Control (v1.0.0)

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

### File Shelf (v1.1.0)

Quick file management directly from the notch:

- **File Storage**:

  - Drag and drop files into the shelf for temporary storage
  - Files are displayed with their native icons
  - Horizontal scrollable view supports multiple files
  - Files are added to the beginning of the shelf (most recent first)

- **File Operations**:

  - **Remove**: Click the X button on any file to remove it from the shelf
  - **Drag Out**: Drag files from the shelf to other applications or locations
  - **Visual Feedback**: Clear visual indicators when dragging files over the shelf

- **AirDrop Integration**:

  - Dedicated AirDrop zone for quick file sharing
  - Drop files on the AirDrop zone to trigger AirDrop sharing
  - Visual feedback when files are targeted for AirDrop

- **Smart Tab Switching**:
  - Automatically switches to the File tab when dragging files near the notch
  - Seamless integration with the notch expansion system

### Webcam (v1.5.0)

Live webcam preview directly in the notch:

- **Camera Preview**:

  - Live webcam feed displayed in the notch
  - Toggle camera on/off with a single tap
  - Mirrored preview for natural viewing

- **Shape Options**:

  - Rounded Rectangle (default)
  - Circle
  - Rectangle

- **Smart Integration**:
  - Option to keep notch expanded while camera is running
  - Camera automatically stops when view disappears
  - Separate webcam tab option available

### Settings (v1.5.0)

Comprehensive settings panel to customize your experience:

- **General Settings**:

  - Notch size (Small, Medium, Large)
  - Notch color selection
  - Expand sensitivity (Fast, Medium, Slow)
  - Enable/disable AirDrop
  - Launch at login

- **Music Control Settings**:

  - Spectrum color customization
  - Notch border toggle and color
  - Extend notch when playing option

- **File Shelf Settings**:

  - Open file when has item
  - Grab bunch option

- **Webcam Settings**:
  - Enable/disable webcam
  - Webcam shape selection
  - Keep notch extended when camera on
  - Separate webcam tab option

## 🏗️ Project Structure

```
awesome-notch/
├── awesome-notch/
│   ├── awesome_notchApp.swift          # Main app entry point
│   │
│   ├── components/
│   │   ├── notch/
│   │   │   ├── manager/
│   │   │   │   ├── NotchWindowController.swift  # Window management & animations
│   │   │   │   └── TabManager.swift             # Tab state management
│   │   │   └── view/
│   │   │       ├── NotchView.swift              # Main notch UI component
│   │   │       └── NotchShape.swift             # Custom notch shape drawing
│   │   │
│   │   ├── mediaContol/
│   │   │   ├── MusicManager.swift          # MediaRemote integration & state
│   │   │   └── AudioSpectrum.swift         # Audio visualization component
│   │   │
│   │   ├── fileShelf/
│   │   │   ├── manager/
│   │   │   │   ├── ShelfManager.swift      # File shelf state management
│   │   │   │   └── AirDropManager.swift    # AirDrop service integration
│   │   │   ├── model/
│   │   │   │   └── ShelfItem.swift         # File item data model
│   │   │   └── view/
│   │   │       ├── NotchShelfView.swift    # File shelf UI component
│   │   │       ├── AirDropZoneView.swift   # AirDrop drop zone UI
│   │   │       ├── ItemDragView.swift      # Single item drag view
│   │   │       └── MultiItemDragView.swift # Multiple items drag view
│   │   │
│   │   ├── webcame/
│   │   │   ├── manager/
│   │   │   │   └── CameraManager.swift     # Camera session management
│   │   │   └── view/
│   │   │       ├── NotchCameraView.swift   # Webcam preview component
│   │   │       └── CameraPreview.swift     # Camera preview layer
│   │   │
│   │   └── setting/
│   │       ├── constraint/
│   │       │   ├── NotchSize.swift         # Notch size options
│   │       │   └── WebcameShape.swift      # Webcam shape options
│   │       ├── manager/
│   │       │   └── SettingsManager.swift   # App settings management
│   │       └── view/
│   │           ├── General.swift           # General settings view
│   │           ├── Appearance.swift        # Appearance settings view
│   │           ├── MusicControl.swift      # Music control settings view
│   │           ├── FileShelf.swift         # File shelf settings view
│   │           ├── Webcame.swift           # Webcam settings view
│   │           └── About.swift             # About view
│   │
│   ├── view/
│   │   ├── NotchTabs.swift                 # Tab navigation (Home/File)
│   │   ├── HomeView.swift                  # Music control interface
│   │   ├── FileView.swift                  # File management interface
│   │   └── SettingsView.swift              # Settings panel
│   │
│   ├── utils/
│   │   ├── GetNotchDimension.swift         # Notch size detection
│   │   ├── TrackingView.swift              # Mouse tracking utilities
│   │   └── LaunchManager.swift             # Launch at login management
│   │
│   └── resource/
│       └── Assets.xcassets/                # App assets and icons
│
└── awesome-notch.xcodeproj/                # Xcode project files
```

## 🔧 Technical Details

### Architecture

- **SwiftUI** for UI components
- **AppKit** for window management and system integration
- **MediaRemote Framework** (private) for music control
- **AVFoundation** for camera/webcam functionality
- **Combine** for reactive state management
- **ServiceManagement** for launch at login

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

4. **ShelfManager**:

   - Singleton that manages the file shelf state
   - Handles file drop operations
   - Manages file items collection
   - Provides file removal functionality

5. **AirDropManager**:
   - Handles AirDrop file sharing operations
   - Integrates with macOS NSSharingService
   - Manages file provider handling for AirDrop

6. **CameraManager**:
   - Manages AVCaptureSession for webcam preview
   - Handles camera permissions
   - Provides start/stop session functionality

7. **SettingsManager**:
   - Singleton that manages all app settings
   - Uses @AppStorage for persistent storage
   - Provides computed properties for complex settings

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

### File Shelf

1. **Switch to File Tab**: Click the tray icon in the expanded notch interface
2. **Add Files**: Drag and drop files from Finder or any application into the file shelf area
3. **Remove Files**: Click the X button on any file icon to remove it from the shelf
4. **Drag Files Out**: Drag files from the shelf to other applications or Finder windows
5. **Use AirDrop**: Drop files on the AirDrop zone (left side) to quickly share via AirDrop
6. **Auto-Switch**: When dragging files near the notch, it automatically switches to the File tab

### Webcam

1. **Enable Webcam**: The webcam appears in the home tab when enabled in settings
2. **Toggle Camera**: Tap the webcam preview to turn the camera on/off
3. **Change Shape**: Go to Settings → Webcam to change the preview shape
4. **Keep Expanded**: Enable "Keep Notch Extended When Camera On" to prevent collapse while camera is active

### Settings

Access settings by clicking the gear icon in the expanded notch interface:

1. **General**: Configure notch size, color, expand sensitivity, and launch at login
2. **Music Control**: Customize spectrum colors, notch border, and extend behavior
3. **File Shelf**: Configure file handling options
4. **Webcam**: Enable/disable webcam, choose shape, configure expansion behavior
5. **About**: View app information

## 🔮 Future Features

The following features are planned for future releases:

- **Unknow**: Comming soon!

## 🛠️ Development

### Current Branch

- **feature/setting**: Settings and webcam feature implementation

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

**Version 1.5.3** - Music Control, File Shelf, Webcam, Settings & AirDrop Release
