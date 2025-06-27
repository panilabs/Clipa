//
//  ClipboardListView.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import SwiftUI
import CoreData
import AppKit

struct ClipboardListView: View {
    @StateObject private var clipboardManager = ClipboardManager()
    @State private var searchText = ""
    @State private var showingSettings = false
    @State private var selectedIndex = 0
    @State private var showingToast = false
    @State private var toastMessage = ""
    
    private var filteredEntries: [ClipboardEntry] {
        clipboardManager.searchEntries(query: searchText)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Clipa")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    showingSettings.toggle()
                }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 12))
                
                TextField("Search clipboard history...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 12))
                    .onChange(of: searchText) { _ in
                        selectedIndex = 0
                    }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Clipboard Entries List
            if filteredEntries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clipboard")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                    
                    Text(searchText.isEmpty ? "No clipboard history yet" : "No matching entries")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    if searchText.isEmpty {
                        Text("Copy some text to get started!")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(filteredEntries.enumerated()), id: \.element.id) { index, entry in
                            ClipboardEntryRow(
                                entry: entry,
                                isSelected: index == selectedIndex,
                                onCopy: {
                                    copyAndPasteEntry(entry)
                                },
                                onPinToggle: {
                                    clipboardManager.togglePin(entry)
                                }
                            )
                            .onTapGesture {
                                selectedIndex = index
                                copyAndPasteEntry(entry)
                            }
                        }
                    }
                }
                .frame(maxHeight: 400)
            }
            
            // Footer with keyboard shortcuts hint
            VStack(spacing: 4) {
                Divider()
                HStack {
                    Text("↑↓ Navigate • Enter Paste • Click Copy")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .frame(width: 350)
        .onAppear {
            selectedIndex = 0
        }
        .onKeyPress(.upArrow) {
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
            return .handled
        }
        .onKeyPress(.downArrow) {
            if selectedIndex < filteredEntries.count - 1 {
                selectedIndex += 1
            }
            return .handled
        }
        .onKeyPress(.return) {
            if !filteredEntries.isEmpty && selectedIndex < filteredEntries.count {
                copyAndPasteEntry(filteredEntries[selectedIndex])
            }
            return .handled
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(isPresented: $showingSettings)
        }
        .overlay(
            // Toast notification
            VStack {
                if showingToast {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(toastMessage)
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showingToast = false
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.top, 8)
            .animation(.easeInOut(duration: 0.3), value: showingToast)
        )
    }
    
    private func copyAndPasteEntry(_ entry: ClipboardEntry) {
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
    
    private func pasteToActiveApp() -> Bool {
        // Simulate Cmd+V to paste
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
    
    private func showToast(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showingToast = true
        }
    }
}

struct ClipboardEntryRow: View {
    let entry: ClipboardEntry
    let isSelected: Bool
    let onCopy: () -> Void
    let onPinToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Pin button
            Button(action: onPinToggle) {
                Image(systemName: entry.isPinned ? "pin.fill" : "pin")
                    .font(.system(size: 12))
                    .foregroundColor(entry.isPinned ? .orange : .secondary)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.content ?? "")
                    .font(.system(size: 13))
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                if let timestamp = entry.timestamp {
                    Text(timestamp, style: .relative)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Copy button
            Button(action: onCopy) {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        .cornerRadius(8)
        .contentShape(Rectangle())
    }
}

struct SettingsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Global Hotkey:")
                        .font(.system(size: 14))
                    Spacer()
                    Text("⌘⇧V")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Auto-save interval:")
                        .font(.system(size: 14))
                    Spacer()
                    Text("5 seconds")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Max entries:")
                        .font(.system(size: 14))
                    Spacer()
                    Text("50")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            Spacer()
            
            Button("Close") {
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 300, height: 250)
    }
}

#Preview {
    ClipboardListView()
} 