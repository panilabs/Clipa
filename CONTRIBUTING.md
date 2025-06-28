# Contributing to Clipa

Thank you for your interest in contributing to Clipa! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### Before You Start

1. **Check existing issues** - Your idea might already be discussed
2. **Read the documentation** - Understand the project structure and architecture
3. **Set up your development environment** - Follow the setup instructions in README.md

### Types of Contributions

We welcome various types of contributions:

- 🐛 **Bug fixes** - Help us squash bugs
- ✨ **New features** - Add functionality that users will love
- 📚 **Documentation** - Improve docs, add examples, fix typos
- 🧪 **Tests** - Add or improve test coverage
- 🎨 **UI/UX improvements** - Enhance the user experience
- 🔧 **Code quality** - Refactor, optimize, or improve code structure

## 🛠️ Development Setup

### Prerequisites

- macOS 15.2 or later
- Xcode 16.0 or later
- Swift 6.0 or later
- Git

### Getting Started

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/clipa.git
   cd clipa
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Open in Xcode**
   ```bash
   open clipa.xcodeproj
   ```

4. **Build and test**
   ```bash
   xcodebuild -project clipa.xcodeproj -scheme clipa -configuration Debug build
   ```

## 📝 Code Style Guidelines

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) and these additional rules:

#### Naming Conventions

```swift
// ✅ Good
class ClipboardManager { }
func saveClipboardEntry(_ content: String) { }
let maxEntries: Int = 50

// ❌ Bad
class clipboardManager { }
func SaveClipboardEntry(content: String) { }
let MaxEntries: Int = 50
```

#### Documentation

All public APIs must be documented:

```swift
/// Manages clipboard monitoring and Core Data operations.
/// Handles automatic clipboard saving, duplicate prevention, and data persistence.
@MainActor
final class ClipboardManager: ObservableObject {
    
    /// Searches clipboard entries based on the provided query
    /// - Parameter query: The search query string
    /// - Returns: Filtered array of clipboard entries matching the query
    func searchEntries(query: String) -> [ClipboardEntry] {
        // Implementation
    }
}
```

#### File Organization

Use MARK comments to organize code:

```swift
// MARK: - Properties
@Published private(set) var clipboardEntries: [ClipboardEntry] = []

// MARK: - Public Methods
extension ClipboardManager {
    func searchEntries(query: String) -> [ClipboardEntry] { }
}

// MARK: - Private Methods
private extension ClipboardManager {
    func saveContext() { }
}
```

#### Error Handling

Always handle errors gracefully:

```swift
do {
    try context.save()
} catch {
    Logger.error("Failed to save context: \(error)")
}
```

### SwiftUI Guidelines

#### View Structure

```swift
struct MyView: View {
    // MARK: - Properties
    @StateObject private var viewModel = MyViewModel()
    @State private var showingAlert = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            headerView
            contentView
            footerView
        }
    }
}

// MARK: - View Components
private extension MyView {
    var headerView: some View {
        Text("Header")
    }
}
```

#### Constants

Define constants in a private enum:

```swift
private extension MyView {
    enum Constants {
        static let padding: CGFloat = 16
        static let cornerRadius: CGFloat = 8
        static let animationDuration: Double = 0.3
    }
}
```

## 🧪 Testing Guidelines

### Writing Tests

1. **Test all public APIs**
2. **Use descriptive test names**
3. **Follow AAA pattern (Arrange, Act, Assert)**

```swift
func testSearchEntries_WithEmptyQuery_ReturnsAllEntries() {
    // Arrange
    let manager = ClipboardManager()
    let expectedCount = 5
    
    // Act
    let result = manager.searchEntries(query: "")
    
    // Assert
    XCTAssertEqual(result.count, expectedCount)
}
```

### Running Tests

```bash
# Run all tests
xcodebuild test -project clipa.xcodeproj -scheme clipa

# Run with coverage
xcodebuild test -project clipa.xcodeproj -scheme clipa -enableCodeCoverage YES
```

## 📋 Pull Request Process

### Before Submitting

1. **Ensure your code builds successfully**
2. **Run all tests and ensure they pass**
3. **Update documentation** if needed
4. **Test your changes** thoroughly

### Pull Request Template

Use this template when creating a PR:

```markdown
## Description
Brief description of the changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring
- [ ] Test addition/update

## Testing
- [ ] All tests pass
- [ ] Manual testing completed
- [ ] No regressions introduced

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
```

### Review Process

1. **Automated checks** must pass
2. **Code review** by maintainers
3. **Testing** on different macOS versions
4. **Documentation** review

## 🐛 Bug Reports

### Before Reporting

1. **Check existing issues** for duplicates
2. **Try the latest version** from main branch
3. **Reproduce the issue** consistently

### Bug Report Template

```markdown
## Bug Description
Clear description of the issue

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- macOS Version: 
- Xcode Version: 
- Clipa Version: 

## Additional Information
Screenshots, logs, etc.
```

## 💡 Feature Requests

### Before Requesting

1. **Check existing issues** for similar requests
2. **Consider the impact** on existing functionality
3. **Think about implementation** complexity

### Feature Request Template

```markdown
## Feature Description
Clear description of the requested feature

## Use Case
Why this feature would be useful

## Proposed Implementation
How you think it could be implemented

## Alternatives Considered
Other approaches you've considered
```

## 🏷️ Issue Labels

We use these labels to categorize issues:

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements or additions to documentation
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention is needed
- `question` - Further information is requested

## 📞 Getting Help

### Communication Channels

- **GitHub Issues** - For bugs and feature requests
- **GitHub Discussions** - For questions and general discussion
- **Pull Requests** - For code reviews and feedback

### Code of Conduct

We are committed to providing a welcoming and inspiring community for all. Please read our [Code of Conduct](CODE_OF_CONDUCT.md) for details.

## 🎉 Recognition

Contributors will be recognized in:

- **README.md** - For significant contributions
- **Release notes** - For each release
- **Contributors list** - On GitHub

## 📄 License

By contributing to Clipa, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Clipa! 🚀 