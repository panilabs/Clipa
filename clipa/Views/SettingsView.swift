//
//  SettingsView.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import SwiftUI

/// Settings view displayed as a sheet from the main clipboard interface.
/// Shows app configuration and current settings.
struct SettingsView: View {
    // MARK: - Properties
    
    @Binding var isPresented: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: Constants.spacing) {
            headerView
            settingsSection
            Spacer()
            closeButton
        }
        .padding()
        .frame(width: Constants.width, height: Constants.height)
    }
}

// MARK: - View Components

private extension SettingsView {
    
    /// Header section with title
    var headerView: some View {
        Text("Settings")
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    /// Main settings content section
    var settingsSection: some View {
        VStack(alignment: .leading, spacing: Constants.settingsSpacing) {
            settingRow(title: "Global Hotkey:", value: "⌘⇧V", isMonospaced: true)
            settingRow(title: "Auto-save interval:", value: "5 seconds")
            settingRow(title: "Max entries:", value: "50")
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(Constants.cornerRadius)
    }
    
    /// Close button
    var closeButton: some View {
        Button("Close") {
            isPresented = false
        }
        .buttonStyle(.borderedProminent)
    }
}

// MARK: - Helper Methods

private extension SettingsView {
    
    /// Creates a setting row with title and value
    /// - Parameters:
    ///   - title: The setting title
    ///   - value: The setting value
    ///   - isMonospaced: Whether the value should use monospaced font
    func settingRow(title: String, value: String, isMonospaced: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.system(size: Constants.fontSize))
            Spacer()
            Text(value)
                .font(.system(size: Constants.fontSize, design: isMonospaced ? .monospaced : .default))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Constants

private extension SettingsView {
    
    enum Constants {
        static let width: CGFloat = 300
        static let height: CGFloat = 250
        static let spacing: CGFloat = 20
        static let settingsSpacing: CGFloat = 16
        static let fontSize: CGFloat = 14
        static let cornerRadius: CGFloat = 8
    }
}

// MARK: - Preview

#Preview {
    SettingsView(isPresented: .constant(true))
} 