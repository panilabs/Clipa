//
//  ClipboardManager.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import Foundation
import CoreData
import AppKit

class ClipboardManager: ObservableObject {
    private let pasteboard = NSPasteboard.general
    private var timer: Timer?
    private var lastClipboardContent: String?
    private let maxEntries = 50
    
    @Published var clipboardEntries: [ClipboardEntry] = []
    
    init() {
        startMonitoring()
        loadEntries()
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkClipboard() {
        guard let content = pasteboard.string(forType: .string),
              !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        // Only save if content has changed
        if content != lastClipboardContent {
            lastClipboardContent = content
            saveClipboardContent(content)
        }
    }
    
    private func saveClipboardContent(_ content: String) {
        let context = PersistenceController.shared.container.viewContext
        
        // Check if content already exists (prevent duplicates)
        let fetchRequest: NSFetchRequest<ClipboardEntry> = ClipboardEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "content == %@", content)
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            if !existingEntries.isEmpty {
                // Update timestamp of existing entry
                existingEntries.first?.timestamp = Date()
                try context.save()
                loadEntries()
                return
            }
        } catch {
            print("Error checking for duplicates: \(error)")
        }
        
        // Create new entry
        let newEntry = ClipboardEntry(context: context)
        newEntry.id = UUID()
        newEntry.content = content
        newEntry.timestamp = Date()
        newEntry.isPinned = false
        
        // Enforce max entries limit (remove oldest unpinned entries)
        enforceMaxEntriesLimit(context: context)
        
        do {
            try context.save()
            loadEntries()
        } catch {
            print("Error saving clipboard entry: \(error)")
        }
    }
    
    private func enforceMaxEntriesLimit(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ClipboardEntry> = ClipboardEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ClipboardEntry.timestamp, ascending: true)]
        
        do {
            let allEntries = try context.fetch(fetchRequest)
            let unpinnedEntries = allEntries.filter { !$0.isPinned }
            
            if allEntries.count >= maxEntries {
                let entriesToDelete = unpinnedEntries.prefix(allEntries.count - maxEntries + 1)
                for entry in entriesToDelete {
                    context.delete(entry)
                }
            }
        } catch {
            print("Error enforcing max entries limit: \(error)")
        }
    }
    
    func loadEntries() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<ClipboardEntry> = ClipboardEntry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \ClipboardEntry.isPinned, ascending: false),
            NSSortDescriptor(keyPath: \ClipboardEntry.timestamp, ascending: false)
        ]
        
        do {
            clipboardEntries = try context.fetch(fetchRequest)
        } catch {
            print("Error loading clipboard entries: \(error)")
            clipboardEntries = []
        }
    }
    
    func togglePin(for entry: ClipboardEntry) {
        let context = PersistenceController.shared.container.viewContext
        entry.isPinned.toggle()
        
        do {
            try context.save()
            loadEntries()
        } catch {
            print("Error toggling pin: \(error)")
        }
    }
    
    func copyToClipboard(_ content: String) {
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        lastClipboardContent = content
    }
    
    func deleteEntry(_ entry: ClipboardEntry) {
        let context = PersistenceController.shared.container.viewContext
        context.delete(entry)
        
        do {
            try context.save()
            loadEntries()
        } catch {
            print("Error deleting entry: \(error)")
        }
    }
    
    func searchEntries(query: String) -> [ClipboardEntry] {
        if query.isEmpty {
            return clipboardEntries
        }
        
        return clipboardEntries.filter { entry in
            entry.content?.localizedCaseInsensitiveContains(query) == true
        }
    }
    
    func togglePin(_ entry: ClipboardEntry) {
        entry.isPinned.toggle()
        saveContext()
        loadEntries()
    }
    
    private func saveContext() {
        let context = PersistenceController.shared.container.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
} 