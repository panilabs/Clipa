//
//  ClipboardEntryRow.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import SwiftUI

/// A row component representing a single clipboard entry in the history list.
/// Displays the entry content, timestamp, pin status, and provides copy/pin actions.
struct ClipboardEntryRow: View {
    // MARK: - Properties
    
    let entry: ClipboardEntry
    let isSelected: Bool
    let onCopy: () -> Void
    let onPinToggle: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: Constants.spacing) {
            pinButton
            contentSection
            Spacer()
            copyButton
        }
        .padding(.horizontal, Constants.padding)
        .padding(.vertical, Constants.verticalPadding)
        .background(selectionBackground)
        .cornerRadius(Constants.cornerRadius)
        .contentShape(Rectangle())
    }
}

// MARK: - View Components

private extension ClipboardEntryRow {
    
    /// Pin/unpin button for the clipboard entry
    var pinButton: some View {
        Button(action: onPinToggle) {
            Image(systemName: entry.isPinned ? "pin.fill" : "pin")
                .font(.system(size: Constants.iconSize))
                .foregroundColor(pinColor)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Main content section with text and timestamp
    var contentSection: some View {
        VStack(alignment: .leading, spacing: Constants.contentSpacing) {
            Text(entry.content ?? "")
                .font(.system(size: Constants.fontSize))
                .lineLimit(Constants.maxLines)
                .foregroundColor(.primary)
            
            if let timestamp = entry.timestamp {
                Text(timestamp, style: .relative)
                    .font(.system(size: Constants.timestampFontSize))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    /// Copy button for the clipboard entry
    var copyButton: some View {
        Button(action: onCopy) {
            Image(systemName: "doc.on.doc")
                .font(.system(size: Constants.iconSize))
                .foregroundColor(.secondary)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Background color based on selection state
    var selectionBackground: Color {
        isSelected ? Color.accentColor.opacity(Constants.selectionOpacity) : Color.clear
    }
    
    /// Color for the pin button based on pin status
    var pinColor: Color {
        entry.isPinned ? .orange : .secondary
    }
}

// MARK: - Constants

private extension ClipboardEntryRow {
    
    enum Constants {
        static let spacing: CGFloat = 12
        static let padding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
        static let contentSpacing: CGFloat = 4
        static let cornerRadius: CGFloat = 8
        static let fontSize: CGFloat = 13
        static let timestampFontSize: CGFloat = 11
        static let iconSize: CGFloat = 12
        static let maxLines: Int = 2
        static let selectionOpacity: Double = 0.1
    }
}

// MARK: - Preview

#Preview {
    VStack {
        ClipboardEntryRow(
            entry: ClipboardEntry(),
            isSelected: false,
            onCopy: {},
            onPinToggle: {}
        )
        
        ClipboardEntryRow(
            entry: ClipboardEntry(),
            isSelected: true,
            onCopy: {},
            onPinToggle: {}
        )
    }
    .padding()
} 