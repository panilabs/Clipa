//
//  clipaApp.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import SwiftUI

@main
struct clipaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
