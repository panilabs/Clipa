//
//  MenuBarManager.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import SwiftUI
import AppKit

/// Manages the menu bar integration, status item, and popover display.
/// Handles the global hotkey registration and menu bar interactions.
@MainActor
final class MenuBarManager: NSObject, ObservableObject {
    // MARK: - Properties
    
    @Published private(set) var isPopoverShown = false
    
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var hotKey: HotKey?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupStatusItem()
        setupPopover()
        setupHotKey()
    }
    
    deinit {
        Task { @MainActor in
            cleanup()
        }
    }
}

// MARK: - Public Methods

extension MenuBarManager {
    
    /// Toggles the popover visibility
    func togglePopover() {
        if isPopoverShown {
            hidePopover()
        } else {
            showPopover()
        }
    }
    
    /// Shows the popover
    func showPopover() {
        guard let statusItem = statusItem,
              let popover = popover else {
            Logger.error("Status item or popover not initialized")
            return
        }
        
        guard let button = statusItem.button else {
            Logger.error("Status item button not available")
            return
        }
        
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        isPopoverShown = true
        
        Logger.info("Popover shown")
    }
    
    /// Hides the popover
    func hidePopover() {
        popover?.performClose(nil)
        isPopoverShown = false
        
        Logger.info("Popover hidden")
    }
}

// MARK: - Private Setup Methods

private extension MenuBarManager {
    
    /// Sets up the status bar item
    func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusItem = statusItem else {
            Logger.error("Failed to create status item")
            return
        }
        
        guard let button = statusItem.button else {
            Logger.error("Status item button not available")
            return
        }
        
        button.image = NSImage(systemSymbolName: Constants.statusItemIcon, accessibilityDescription: Constants.appName)
        button.action = #selector(handleStatusItemClick)
        button.target = self
        
        Logger.info("Status item setup completed")
    }
    
    /// Sets up the popover
    func setupPopover() {
        popover = NSPopover()
        
        guard let popover = popover else {
            Logger.error("Failed to create popover")
            return
        }
        
        popover.contentSize = Constants.popoverSize
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ClipboardListView())
        popover.delegate = self
        
        Logger.info("Popover setup completed")
    }
    
    /// Sets up the global hotkey
    func setupHotKey() {
        hotKey = HotKey(keyCombo: Constants.defaultHotKeyCombo)
        hotKey?.keyDownHandler = { [weak self] in
            Task { @MainActor in
                self?.togglePopover()
            }
        }
        
        Logger.info("Global hotkey setup completed")
    }
    
    /// Cleans up resources
    func cleanup() {
        stopMonitoring()
        removeStatusItem()
    }
    
    /// Stops monitoring and removes the status item
    func stopMonitoring() {
        hotKey?.keyDownHandler = nil
        hotKey = nil
    }
    
    /// Removes the status item from the menu bar
    func removeStatusItem() {
        statusItem?.button?.action = nil
        statusItem?.button?.target = nil
        statusItem = nil
    }
}

// MARK: - Action Handlers

private extension MenuBarManager {
    
    /// Handles status item button clicks
    @objc func handleStatusItemClick() {
        togglePopover()
    }
}

// MARK: - NSPopoverDelegate

extension MenuBarManager: NSPopoverDelegate {
    
    func popoverDidClose(_ notification: Notification) {
        isPopoverShown = false
        Logger.info("Popover closed by delegate")
    }
}

// MARK: - Constants

private extension MenuBarManager {
    
    enum Constants {
        static let appName = "Clipa"
        static let statusItemIcon = "clipboard"
        static let popoverSize = NSSize(width: 350, height: 500)
        
        static let defaultHotKeyCombo = KeyCombo(
            key: Key.v,
            modifiers: [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.shift]
        )
    }
}

// MARK: - Logger

/// Simple logging utility for the MenuBarManager
private enum Logger {
    static func error(_ message: String) {
        #if DEBUG
        print("🔴 MenuBarManager Error: \(message)")
        #endif
    }
    
    static func info(_ message: String) {
        #if DEBUG
        print("ℹ️ MenuBarManager Info: \(message)")
        #endif
    }
} 