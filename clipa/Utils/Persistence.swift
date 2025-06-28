//
//  Persistence.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample clipboard entries
        let sampleTexts = [
            "Hello, this is a sample clipboard entry!",
            "https://www.example.com",
            "Sample code: let greeting = \"Hello, World!\"",
            "Meeting reminder: Team standup at 9 AM",
            "Shopping list: Milk, Bread, Eggs",
            "Important note: Don't forget to backup data",
            "Phone number: +1 (555) 123-4567",
            "Email: user@example.com"
        ]
        
        for (index, text) in sampleTexts.enumerated() {
            let newEntry = ClipboardEntry(context: viewContext)
            newEntry.id = UUID()
            newEntry.content = text
            newEntry.timestamp = Date().addingTimeInterval(-Double(index * 3600)) // Stagger timestamps
            newEntry.isPinned = index < 2 // Pin first two entries
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "clipa")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
