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
    @StateObject private var menuBarManager = MenuBarManager()

    var body: some Scene {
        Settings {
            EmptyView()
        }
        .commands {
            // Hide the default menu items since this is a menu bar app
            CommandGroup(replacing: .appInfo) { }
            CommandGroup(replacing: .systemServices) { }
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .pasteboard) { }
            CommandGroup(replacing: .undoRedo) { }
            CommandGroup(replacing: .textEditing) { }
            CommandGroup(replacing: .textFormatting) { }
            CommandGroup(replacing: .help) { }
        }
    }
}
