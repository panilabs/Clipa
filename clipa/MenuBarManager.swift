//
//  MenuBarManager.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import SwiftUI
import AppKit

class MenuBarManager: ObservableObject {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var hotKey: HotKey?
    
    @Published var isPopoverShown = false
    
    init() {
        setupStatusItem()
        setupPopover()
        setupHotKey()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "clipboard", accessibilityDescription: "Clipa")
            button.action = #selector(togglePopover)
            button.target = self
        }
    }
    
    private func setupPopover() {
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 400, height: 500)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(
            rootView: ClipboardListView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        )
    }
    
    private func setupHotKey() {
        // Cmd + Shift + V
        hotKey = HotKey(keyCombo: KeyCombo(key: Key.v, modifiers: [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.shift]))
        hotKey?.keyDownHandler = { [weak self] in
            self?.togglePopover()
        }
    }
    
    @objc private func togglePopover() {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(nil)
                isPopoverShown = false
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                isPopoverShown = true
            }
        }
    }
    
    func hidePopover() {
        popover?.performClose(nil)
        isPopoverShown = false
    }
} 