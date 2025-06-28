//
//  ClipboardManager.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import Foundation
import CoreData
import AppKit

/// Manages clipboard monitoring, Core Data operations, and clipboard history.
/// Handles automatic clipboard saving, duplicate prevention, and data persistence.
@MainActor
final class ClipboardManager: ObservableObject {
    // MARK: - Properties
    
    @Published private(set) var clipboardEntries: [ClipboardEntry] = []
    
    private let pasteboard = NSPasteboard.general
    private var timer: Timer?
    private var lastClipboardContent: String?
    private let maxEntries: Int
    
    // MARK: - Initialization
    
    init(maxEntries: Int = Constants.defaultMaxEntries) {
        self.maxEntries = maxEntries
        startMonitoring()
        loadEntries()
    }
    
    deinit {
        Task { @MainActor in
            stopMonitoring()
        }
    }
}

// MARK: - Public Methods

extension ClipboardManager {
    
    /// Searches clipboard entries based on the provided query
    /// - Parameter query: The search query string
    /// - Returns: Filtered array of clipboard entries matching the query
    func searchEntries(query: String) -> [ClipboardEntry] {
        guard !query.isEmpty else { return clipboardEntries }
        
        return clipboardEntries.filter { entry in
            entry.content?.localizedCaseInsensitiveContains(query) == true
        }
    }
    
    /// Toggles the pin status of a clipboard entry
    /// - Parameter entry: The clipboard entry to toggle pin status
    func togglePin(_ entry: ClipboardEntry) {
        entry.isPinned.toggle()
        saveContext()
        loadEntries()
    }
    
    /// Starts monitoring the clipboard for changes
    func startMonitoring() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.monitoringInterval,
            repeats: true
        ) { [weak self] _ in
            Task { @MainActor in
                self?.checkClipboard()
            }
        }
    }
    
    /// Stops monitoring the clipboard for changes
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Private Methods

private extension ClipboardManager {
    
    /// Checks the clipboard for new content and saves it if changed
    func checkClipboard() {
        guard let currentContent = pasteboard.string(forType: .string),
              currentContent != lastClipboardContent,
              !currentContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        saveClipboardEntry(currentContent)
        lastClipboardContent = currentContent
    }
    
    /// Saves a new clipboard entry to Core Data
    /// - Parameter content: The clipboard content to save
    func saveClipboardEntry(_ content: String) {
        let context = PersistenceController.shared.container.viewContext
        
        // Check for duplicates
        if isDuplicate(content: content, in: context) {
            return
        }
        
        // Create new entry
        let entry = ClipboardEntry(context: context)
        entry.id = UUID()
        entry.content = content
        entry.timestamp = Date()
        entry.isPinned = false
        
        // Save context
        saveContext()
        
        // Load updated entries
        loadEntries()
        
        // Clean up old entries if needed
        cleanupOldEntries()
    }
    
    /// Checks if the content already exists in the clipboard history
    /// - Parameters:
    ///   - content: The content to check
    ///   - context: The Core Data context
    /// - Returns: `true` if the content is a duplicate, `false` otherwise
    func isDuplicate(content: String, in context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<ClipboardEntry> = ClipboardEntry.fetchRequest()
        request.predicate = NSPredicate(format: "content == %@", content)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            Logger.error("Failed to check for duplicates: \(error)")
            return false
        }
    }
    
    /// Loads clipboard entries from Core Data
    func loadEntries() {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<ClipboardEntry> = ClipboardEntry.fetchRequest()
        
        // Sort by timestamp (newest first) and pin status (pinned first)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ClipboardEntry.isPinned, ascending: false),
            NSSortDescriptor(keyPath: \ClipboardEntry.timestamp, ascending: false)
        ]
        
        do {
            clipboardEntries = try context.fetch(request)
        } catch {
            Logger.error("Failed to load clipboard entries: \(error)")
            clipboardEntries = []
        }
    }
    
    /// Cleans up old entries to maintain the maximum limit
    func cleanupOldEntries() {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<ClipboardEntry> = ClipboardEntry.fetchRequest()
        
        // Sort by timestamp (oldest first) and pin status (unpinned first)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ClipboardEntry.isPinned, ascending: true),
            NSSortDescriptor(keyPath: \ClipboardEntry.timestamp, ascending: true)
        ]
        
        do {
            let allEntries = try context.fetch(request)
            
            // Remove unpinned entries that exceed the limit
            let pinnedEntries = allEntries.filter { $0.isPinned }
            let unpinnedEntries = allEntries.filter { !$0.isPinned }
            
            let availableSlots = maxEntries - pinnedEntries.count
            let entriesToDelete = Array(unpinnedEntries.dropFirst(availableSlots))
            
            // Delete excess entries
            entriesToDelete.forEach { context.delete($0) }
            
            if !entriesToDelete.isEmpty {
                saveContext()
                loadEntries()
            }
        } catch {
            Logger.error("Failed to cleanup old entries: \(error)")
        }
    }
    
    /// Saves the Core Data context
    func saveContext() {
        let context = PersistenceController.shared.container.viewContext
        
        do {
            try context.save()
        } catch {
            Logger.error("Failed to save context: \(error)")
        }
    }
}

// MARK: - Constants

private extension ClipboardManager {
    
    enum Constants {
        static let defaultMaxEntries = 50
        static let monitoringInterval: TimeInterval = 5.0
    }
}

// MARK: - Logger

/// Simple logging utility for the ClipboardManager
private enum Logger {
    static func error(_ message: String) {
        #if DEBUG
        print("🔴 ClipboardManager Error: \(message)")
        #endif
    }
    
    static func info(_ message: String) {
        #if DEBUG
        print("ℹ️ ClipboardManager Info: \(message)")
        #endif
    }
} 