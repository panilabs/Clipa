# Clipa - macOS Clipboard Manager

A modern, native macOS menu bar clipboard manager built with SwiftUI and CoreData. Clipa automatically saves your clipboard history, allows you to pin important items, and provides quick access through a global hotkey.

## 🎯 Features

### ✅ Core Features
- **📋 Clipboard History** - Automatically saves copied text (up to 50 entries)
- **📌 Pin/Unpin Items** - Pin important clipboard items so they don't get deleted
- **🔍 Search Filter** - Search through previous clipboard items by keyword
- **🍎 Menu Bar Interface** - Click the clipboard icon in the menu bar to access history
- **⏰ Auto-Save Clipboard** - Checks clipboard every 5 seconds and saves new content
- **💾 CoreData Storage** - Persistent local storage with text, timestamp, and pin status
- **🔄 Duplicate Prevention** - Prevents saving duplicate clipboard entries
- **⌨️ Keyboard Navigation** - Use arrow keys to navigate and Enter to paste
- **🌐 Global Hotkey** - Press `Cmd+Shift+V` to toggle the clipboard history

### 🚀 Future Features (Planned)
- **🚀 Launch at Login** - Option to start Clipa automatically
- **🎨 Customizable Hotkeys** - Configure your preferred keyboard shortcuts
- **📱 iCloud Sync** - Sync clipboard history across devices
- **🔒 Privacy Mode** - Option to disable clipboard monitoring
- **📊 Usage Statistics** - View clipboard usage patterns
- **🎯 Smart Suggestions** - AI-powered clipboard suggestions

## 🛠️ Tech Stack

- **Platform**: macOS 15.2+
- **Language**: Swift 6.0+
- **UI Framework**: SwiftUI + AppKit
- **Data Persistence**: CoreData
- **Architecture**: MVVM with ObservableObject
- **Build System**: Xcode 16.0+

## 📁 Project Structure

```
clipa/
├── clipa/
│   ├── Views/                    # SwiftUI Views
│   │   ├── ClipboardListView.swift
│   │   ├── ClipboardEntryRow.swift
│   │   ├── SettingsView.swift
│   │   └── ContentView.swift
│   ├── Managers/                 # Business Logic Managers
│   │   ├── ClipboardManager.swift
│   │   └── MenuBarManager.swift
│   ├── Utils/                    # Utilities and Helpers
│   │   ├── HotKey.swift
│   │   └── Persistence.swift
│   ├── Models/                   # Data Models (CoreData)
│   ├── Assets.xcassets/          # App Assets
│   ├── clipa.entitlements        # App Entitlements
│   ├── clipa.xcdatamodeld/       # CoreData Model
│   ├── clipaApp.swift            # App Entry Point
│   ├── Info.plist               # App Configuration
│   └── Preview Content/          # SwiftUI Previews
├── clipa.xcodeproj/             # Xcode Project
└── README.md                    # This File
```

## 🚀 Getting Started

### Prerequisites
- macOS 15.2 or later
- Xcode 16.0 or later
- Swift 6.0 or later

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/clipa.git
   cd clipa
   ```

2. **Open in Xcode**
   ```bash
   open clipa.xcodeproj
   ```

3. **Build and Run**
   - Select the `clipa` scheme
   - Press `Cmd+R` to build and run
   - The app will appear in your menu bar

### First Run
- Click the clipboard icon in the menu bar
- Copy some text to see it appear in the history
- Use `Cmd+Shift+V` to quickly access the clipboard history

## 🎮 Usage

### Basic Operations
- **Copy Text**: Any text you copy will automatically appear in Clipa
- **Access History**: Click the menu bar icon or press `Cmd+Shift+V`
- **Search**: Type in the search bar to filter clipboard entries
- **Pin Items**: Click the pin icon to keep important items
- **Quick Paste**: Click an item or press Enter to copy and paste it

### Keyboard Shortcuts
- `Cmd+Shift+V`: Toggle clipboard history
- `↑/↓`: Navigate through entries
- `Enter`: Copy and paste selected entry
- `Esc`: Close the popover

## 🏗️ Architecture

### Design Patterns
- **MVVM**: Model-View-ViewModel architecture
- **ObservableObject**: SwiftUI state management
- **Dependency Injection**: Clean separation of concerns
- **Protocol-Oriented Programming**: Flexible and testable code

### Key Components

#### ClipboardManager
- Manages clipboard monitoring and CoreData operations
- Handles duplicate prevention and entry cleanup
- Provides search functionality

#### MenuBarManager
- Manages menu bar integration and popover display
- Handles global hotkey registration
- Controls app lifecycle

#### Views
- **ClipboardListView**: Main interface for clipboard history
- **ClipboardEntryRow**: Individual clipboard entry display
- **SettingsView**: App configuration and settings

## 🧪 Development

### Code Style
- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Add comprehensive documentation comments
- Keep functions small and focused
- Use proper error handling

### Testing
```bash
# Run tests
xcodebuild test -project clipa.xcodeproj -scheme clipa

# Run with coverage
xcodebuild test -project clipa.xcodeproj -scheme clipa -enableCodeCoverage YES
```

### Debugging
- Enable debug logging in `ClipboardManager` and `MenuBarManager`
- Use Xcode's Core Data debugging tools
- Monitor clipboard access in Console.app

## 🤝 Contributing

We welcome contributions! Please read our contributing guidelines before submitting pull requests.

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
   - Follow the code style guidelines
   - Add tests for new functionality
   - Update documentation as needed
4. **Commit your changes**
   ```bash
   git commit -m "Add amazing feature"
   ```
5. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
6. **Open a Pull Request**

### Development Setup

1. **Install development dependencies**
   ```bash
   # No external dependencies required
   ```

2. **Configure Xcode**
   - Enable "Allow unsigned executables" in Security & Privacy
   - Grant accessibility permissions for global hotkeys

3. **Run development build**
   ```bash
   xcodebuild -project clipa.xcodeproj -scheme clipa -configuration Debug build
   ```

### Code Review Process
1. All changes require review
2. Tests must pass
3. Code must follow style guidelines
4. Documentation must be updated

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [HotKey](https://github.com/soffes/HotKey) by Sam Soffes for global hotkey support
- Apple's SwiftUI and CoreData frameworks
- The macOS development community

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/clipa/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/clipa/discussions)
- **Email**: your.email@example.com

## 🔄 Changelog

### [1.0.0] - 2025-06-28
- Initial release
- Basic clipboard history functionality
- Menu bar integration
- Global hotkey support
- Search and pin features
- Keyboard navigation

---

**Made with ❤️ for the macOS community** 