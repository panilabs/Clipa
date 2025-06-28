//
//  ClipboardListView.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import SwiftUI
import CoreData
import AppKit

/// Main view for displaying clipboard history in a menu bar popover.
/// Provides keyboard navigation, search functionality, and quick paste actions.
struct ClipboardListView: View {
    // MARK: - Properties
    
    @StateObject private var clipboardManager = ClipboardManager()
    @State private var searchText = ""
    @State private var showingSettings = false
    @State private var selectedIndex = 0
    @State private var showingToast = false
    @State private var toastMessage = ""
    
    // MARK: - Computed Properties
    
    private var filteredEntries: [ClipboardEntry] {
        clipboardManager.searchEntries(query: searchText)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            Divider()
            searchBarView
            Divider()
            clipboardEntriesView
            footerView
        }
        .frame(width: Constants.popoverWidth)
        .onAppear(perform: onAppear)
        .onKeyPress(.upArrow, action: handleUpArrow)
        .onKeyPress(.downArrow, action: handleDownArrow)
        .onKeyPress(.return, action: handleReturn)
        .sheet(isPresented: $showingSettings) {
            SettingsView(isPresented: $showingSettings)
        }
        .overlay(toastOverlay)
    }
}

// MARK: - View Components

private extension ClipboardListView {
    
    /// Header section with title and settings button
    var headerView: some View {
        HStack {
            Text("Clipa")
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: { showingSettings.toggle() }) {
                Image(systemName: "gearshape")
                    .font(.system(size: Constants.iconSize))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, Constants.padding)
        .padding(.vertical, Constants.smallPadding)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    /// Search bar for filtering clipboard entries
    var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: Constants.smallIconSize))
            
            TextField("Search clipboard history...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: Constants.smallFontSize))
                .onChange(of: searchText) { _ in
                    selectedIndex = 0
                }
        }
        .padding(.horizontal, Constants.smallPadding)
        .padding(.vertical, Constants.tinyPadding)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    /// Main content area showing clipboard entries or empty state
    var clipboardEntriesView: some View {
        Group {
            if filteredEntries.isEmpty {
                emptyStateView
            } else {
                clipboardEntriesList
            }
        }
    }
    
    /// Empty state when no clipboard entries exist
    var emptyStateView: some View {
        VStack(spacing: Constants.spacing) {
            Image(systemName: "clipboard")
                .font(.system(size: Constants.largeIconSize))
                .foregroundColor(.secondary)
            
            Text(searchText.isEmpty ? "No clipboard history yet" : "No matching entries")
                .font(.system(size: Constants.fontSize))
                .foregroundColor(.secondary)
            
            if searchText.isEmpty {
                Text("Copy some text to get started!")
                    .font(.system(size: Constants.smallFontSize))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, Constants.largePadding)
    }
    
    /// Scrollable list of clipboard entries
    var clipboardEntriesList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(filteredEntries.enumerated()), id: \.element.id) { index, entry in
                    ClipboardEntryRow(
                        entry: entry,
                        isSelected: index == selectedIndex,
                        onCopy: { copyAndPasteEntry(entry) },
                        onPinToggle: { clipboardManager.togglePin(entry) }
                    )
                    .onTapGesture {
                        selectedIndex = index
                        copyAndPasteEntry(entry)
                    }
                }
            }
        }
        .frame(maxHeight: Constants.maxListHeight)
    }
    
    /// Footer with keyboard shortcuts hint
    var footerView: some View {
        VStack(spacing: Constants.tinySpacing) {
            Divider()
            HStack {
                Text("↑↓ Navigate • Enter Paste • Click Copy")
                    .font(.system(size: Constants.tinyFontSize))
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, Constants.padding)
            .padding(.vertical, Constants.tinyPadding)
        }
    }
    
    /// Toast notification overlay
    var toastOverlay: some View {
        VStack {
            if showingToast {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(toastMessage)
                        .font(.system(size: Constants.smallFontSize))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, Constants.smallPadding)
                .padding(.vertical, Constants.tinyPadding)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(Constants.cornerRadius)
                .shadow(radius: Constants.shadowRadius)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    scheduleToastDismissal()
                }
            }
            Spacer()
        }
        .padding(.top, Constants.tinyPadding)
        .animation(.easeInOut(duration: Constants.animationDuration), value: showingToast)
    }
}

// MARK: - Event Handlers

private extension ClipboardListView {
    
    func onAppear() {
        selectedIndex = 0
    }
    
    func handleUpArrow() -> KeyPress.Result {
        if selectedIndex > 0 {
            selectedIndex -= 1
        }
        return .handled
    }
    
    func handleDownArrow() -> KeyPress.Result {
        if selectedIndex < filteredEntries.count - 1 {
            selectedIndex += 1
        }
        return .handled
    }
    
    func handleReturn() -> KeyPress.Result {
        if !filteredEntries.isEmpty && selectedIndex < filteredEntries.count {
            copyAndPasteEntry(filteredEntries[selectedIndex])
        }
        return .handled
    }
}

// MARK: - Business Logic

private extension ClipboardListView {
    
    /// Copies the selected entry to clipboard and attempts to paste it
    /// - Parameter entry: The clipboard entry to copy and paste
    func copyAndPasteEntry(_ entry: ClipboardEntry) {
        guard let content = entry.content else { return }
        
        // Copy to clipboard
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: .string)
        
        // Try to paste automatically
        if pasteToActiveApp() {
            showToast("📋 Text copied and pasted!")
        } else {
            showToast("📋 Text copied to clipboard")
        }
    }
    
    /// Attempts to simulate Cmd+V to paste content into the active application
    /// - Returns: `true` if the paste simulation was successful, `false` otherwise
    func pasteToActiveApp() -> Bool {
        let source = CGEventSource(stateID: .combinedSessionState)
        
        guard let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: true),
              let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: false) else {
            return false
        }
        
        // Add Cmd modifier
        keyDown.flags = .maskCommand
        keyUp.flags = .maskCommand
        
        // Post the events
        keyDown.post(tap: .cghidEventTap)
        keyUp.post(tap: .cghidEventTap)
        
        return true
    }
    
    /// Shows a toast notification with the given message
    /// - Parameter message: The message to display in the toast
    func showToast(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: Constants.animationDuration)) {
            showingToast = true
        }
    }
    
    /// Schedules the toast notification to be dismissed after a delay
    func scheduleToastDismissal() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.toastDuration) {
            withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                showingToast = false
            }
        }
    }
}

// MARK: - Constants

private extension ClipboardListView {
    
    enum Constants {
        static let popoverWidth: CGFloat = 350
        static let maxListHeight: CGFloat = 400
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 12
        static let tinyPadding: CGFloat = 8
        static let largePadding: CGFloat = 40
        static let spacing: CGFloat = 12
        static let tinySpacing: CGFloat = 4
        static let fontSize: CGFloat = 14
        static let smallFontSize: CGFloat = 12
        static let tinyFontSize: CGFloat = 10
        static let iconSize: CGFloat = 14
        static let smallIconSize: CGFloat = 12
        static let largeIconSize: CGFloat = 32
        static let cornerRadius: CGFloat = 8
        static let shadowRadius: CGFloat = 4
        static let animationDuration: Double = 0.3
        static let toastDuration: Double = 2.0
    }
}

// MARK: - Preview

#Preview {
    ClipboardListView()
} 