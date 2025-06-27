# Clipa - macOS Clipboard Manager

A modern, native macOS menu bar clipboard manager built with SwiftUI and CoreData.

## 🎯 Features

### ✅ MVP Features (Implemented)
- **📋 Clipboard History** - Automatically saves copied text (up to 50 entries)
- **📌 Pin/Unpin Items** - Pin important clipboard items so they don't get deleted
- **🔍 Search Filter** - Search through previous clipboard items by keyword
- **🍎 Menu Bar Interface** - Click the clipboard icon in the menu bar to access history
- **⏰ Auto-Save Clipboard** - Checks clipboard every 5 seconds and saves new content
- **💾 CoreData Storage** - Persistent local storage with text, timestamp, and pin status
- **🔄 Duplicate Prevention** - Prevents saving duplicate clipboard entries

### 🚀 Future Features (Planned)
- **🚀 Launch at Login** - Automatically start with macOS
- **⌨️ Global Hotkeys** - Quick access with keyboard shortcuts
- **🎨 Rich Text Support** - Support for formatted text and images
- **📱 iCloud Sync** - Sync clipboard history across devices
- **🔒 Privacy Mode** - Option to not save sensitive clipboard content

## 🛠️ Tech Stack

- **Platform**: macOS (AppKit + SwiftUI)
- **Language**: Swift
- **Storage**: CoreData for persistent local storage
- **Clipboard Access**: NSPasteboard for accessing clipboard content
- **UI**: SwiftUI with native macOS design patterns
- **Architecture**: MVVM with ObservableObject pattern

## 📁 Project Structure

```
clipa/
├── clipaApp.swift              # Main app entry point
├── MenuBarManager.swift        # Menu bar integration and popover
├── ClipboardManager.swift      # Core clipboard monitoring and data management
├── ClipboardListView.swift     # Main UI for clipboard history
├── ContentView.swift           # Placeholder view (not used in menu bar mode)
├── Persistence.swift           # CoreData setup and management
├── clipa.entitlements          # App sandbox and permissions
├── Info.plist                  # App configuration
└── clipa.xcdatamodeld/         # CoreData model
    └── clipa.xcdatamodel/
        └── contents            # ClipboardEntry entity definition
```

## 🚀 Getting Started

### Prerequisites
- macOS 15.2 or later
- Xcode 16.0 or later
- Apple Developer Account (for distribution)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd clipa
   ```

2. **Open in Xcode**
   ```bash
   open clipa.xcodeproj
   ```

3. **Build and Run**
   - Press `Cmd+R` in Xcode, or
   - Use the command line:
     ```bash
     xcodebuild -project clipa.xcodeproj -scheme clipa -configuration Debug build
     open /path/to/build/clipa.app
     ```

### First Run
1. Launch the app - it will appear as a clipboard icon in your menu bar
2. Click the clipboard icon to open the clipboard history
3. Start copying text - it will automatically be saved every 5 seconds
4. Use the search bar to find specific clipboard entries
5. Click the pin icon to keep important items
6. Click any entry to copy it back to your clipboard

## 🎨 Usage

### Menu Bar Interface
- **Click the clipboard icon** in the menu bar to open the history
- **Search** using the search bar at the top
- **Pin items** by clicking the pin icon next to any entry
- **Copy items** by clicking the copy icon or clicking on the entry itself
- **Delete items** by clicking the trash icon

### Keyboard Shortcuts
- **Click to open** - Click the menu bar icon
- **Search** - Type in the search field
- **Copy** - Click on any clipboard entry

## 🔧 Configuration

### App Permissions
The app requires the following permissions (configured in `clipa.entitlements`):
- **App Sandbox** - Required for App Store distribution
- **User Selected Files** - Read/write access for file operations
- **Apple Events** - For automation capabilities

### CoreData Model
The `ClipboardEntry` entity includes:
- `id`: Unique identifier (UUID)
- `content`: The clipboard text content
- `timestamp`: When the entry was created
- `isPinned`: Whether the entry is pinned (won't be auto-deleted)

## 🏗️ Architecture

### MVVM Pattern
- **Model**: `ClipboardEntry` (CoreData entity)
- **View**: `ClipboardListView`, `ClipboardEntryRow`
- **ViewModel**: `ClipboardManager`, `MenuBarManager`

### Key Components

#### ClipboardManager
- Monitors clipboard every 5 seconds
- Prevents duplicate entries
- Manages CoreData operations
- Enforces 50-entry limit (removes oldest unpinned entries)

#### MenuBarManager
- Creates and manages the status bar item
- Handles popover display/hide
- Integrates SwiftUI views with AppKit

#### Persistence
- CoreData stack setup
- Sample data generation for previews
- Error handling for data operations

## 🐛 Troubleshooting

### Common Issues

1. **App doesn't appear in menu bar**
   - Check that the app is running
   - Look for the clipboard icon in the menu bar
   - Ensure no other clipboard managers are conflicting

2. **Clipboard entries not saving**
   - Check app permissions in System Preferences > Security & Privacy
   - Ensure the app has clipboard access
   - Check Console for any error messages

3. **Build errors**
   - Ensure you're using macOS 15.2+ and Xcode 16.0+
   - Clean build folder (Cmd+Shift+K in Xcode)
   - Check that all Swift files are included in the target

### Debug Mode
Run the app from Xcode to see console output and debug information.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with SwiftUI and CoreData
- Inspired by the need for a simple, native macOS clipboard manager
- Uses native macOS design patterns and conventions

---

**Clipa** - Making clipboard management simple and efficient on macOS. 