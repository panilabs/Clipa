//
//  HotKey.swift
//  HotKey
//
//  Created by Sam Soffes on 10/7/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//
//  Source: https://github.com/soffes/HotKey/blob/main/Sources/HotKey/HotKey.swift
//

import AppKit
import Carbon
import Foundation

public struct KeyCombo: Equatable {
    public var key: Key
    public var modifiers: NSEvent.ModifierFlags
    public init(key: Key, modifiers: NSEvent.ModifierFlags) {
        self.key = key
        self.modifiers = modifiers
    }
}

public final class HotKey {
    public var keyCombo: KeyCombo? {
        didSet {
            unregister()
            register()
        }
    }
    public var isPaused: Bool = false {
        didSet {
            if isPaused {
                unregister()
            } else {
                register()
            }
        }
    }
    public var keyDownHandler: (() -> Void)?
    public var keyUpHandler: (() -> Void)?
    private var hotKeyRef: EventHotKeyRef?
    private var hotKeyID: EventHotKeyID
    private static var hotKeyCount: UInt32 = 0
    public init(keyCombo: KeyCombo, keyDownHandler: (() -> Void)? = nil, keyUpHandler: (() -> Void)? = nil) {
        self.keyCombo = keyCombo
        self.keyDownHandler = keyDownHandler
        self.keyUpHandler = keyUpHandler
        HotKey.hotKeyCount += 1
        hotKeyID = EventHotKeyID(signature: OSType("HKEY".fourCharCodeValue), id: HotKey.hotKeyCount)
        register()
    }
    deinit {
        unregister()
    }
    private func register() {
        guard let keyCombo = keyCombo, !isPaused else { return }
        var eventHotKeyRef: EventHotKeyRef?
        let status = RegisterEventHotKey(
            UInt32(keyCombo.key.carbonKeyCode),
            UInt32(keyCombo.modifiers.carbonFlags),
            hotKeyID,
            GetEventDispatcherTarget(),
            0,
            &eventHotKeyRef
        )
        if status == noErr {
            hotKeyRef = eventHotKeyRef
            HotKeyCenter.shared.register(hotKey: self, id: hotKeyID)
        }
    }
    private func unregister() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            HotKeyCenter.shared.unregister(id: hotKeyID)
        }
        hotKeyRef = nil
    }
}

private class HotKeyCenter {
    static let shared = HotKeyCenter()
    private var hotKeys: [UInt32: HotKey] = [:]
    private init() {
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetEventDispatcherTarget(), { (nextHandler, theEvent, userData) -> OSStatus in
            var hotKeyID = EventHotKeyID()
            GetEventParameter(theEvent, UInt32(kEventParamDirectObject), UInt32(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)
            HotKeyCenter.shared.hotKeys[hotKeyID.id]?.keyDownHandler?()
            return noErr
        }, 1, &eventType, nil, nil)
        eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyReleased))
        InstallEventHandler(GetEventDispatcherTarget(), { (nextHandler, theEvent, userData) -> OSStatus in
            var hotKeyID = EventHotKeyID()
            GetEventParameter(theEvent, UInt32(kEventParamDirectObject), UInt32(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)
            HotKeyCenter.shared.hotKeys[hotKeyID.id]?.keyUpHandler?()
            return noErr
        }, 1, &eventType, nil, nil)
    }
    func register(hotKey: HotKey, id: EventHotKeyID) {
        hotKeys[id.id] = hotKey
    }
    func unregister(id: EventHotKeyID) {
        hotKeys.removeValue(forKey: id.id)
    }
}

public enum Key: String {
    case a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
    case zero = "0", one = "1", two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9"
    case returnKey = "return", tab, space, delete, escape, command, shift, option, control, capsLock, function
    case f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, f19, f20
    case home, end, pageUp, pageDown, forwardDelete, leftArrow, rightArrow, downArrow, upArrow
    var carbonKeyCode: Int {
        switch self {
        case .a: return 0
        case .b: return 11
        case .c: return 8
        case .d: return 2
        case .e: return 14
        case .f: return 3
        case .g: return 5
        case .h: return 4
        case .i: return 34
        case .j: return 38
        case .k: return 40
        case .l: return 37
        case .m: return 46
        case .n: return 45
        case .o: return 31
        case .p: return 35
        case .q: return 12
        case .r: return 15
        case .s: return 1
        case .t: return 17
        case .u: return 32
        case .v: return 9
        case .w: return 13
        case .x: return 7
        case .y: return 16
        case .z: return 6
        case .zero: return 29
        case .one: return 18
        case .two: return 19
        case .three: return 20
        case .four: return 21
        case .five: return 23
        case .six: return 22
        case .seven: return 26
        case .eight: return 28
        case .nine: return 25
        case .returnKey: return 36
        case .tab: return 48
        case .space: return 49
        case .delete: return 51
        case .escape: return 53
        case .command: return 55
        case .shift: return 56
        case .option: return 58
        case .control: return 59
        case .capsLock: return 57
        case .function: return 63
        case .f1: return 122
        case .f2: return 120
        case .f3: return 99
        case .f4: return 118
        case .f5: return 96
        case .f6: return 97
        case .f7: return 98
        case .f8: return 100
        case .f9: return 101
        case .f10: return 109
        case .f11: return 103
        case .f12: return 111
        case .f13: return 105
        case .f14: return 107
        case .f15: return 113
        case .f16: return 106
        case .f17: return 64
        case .f18: return 79
        case .f19: return 80
        case .f20: return 90
        case .home: return 115
        case .end: return 119
        case .pageUp: return 116
        case .pageDown: return 121
        case .forwardDelete: return 117
        case .leftArrow: return 123
        case .rightArrow: return 124
        case .downArrow: return 125
        case .upArrow: return 126
        }
    }
}

extension String {
    var fourCharCodeValue: FourCharCode {
        var result: FourCharCode = 0
        if let data = self.data(using: .macOSRoman) {
            for (i, byte) in data.enumerated() {
                result += FourCharCode(byte) << ((3 - i) * 8)
            }
        }
        return result
    }
}

extension NSEvent.ModifierFlags {
    var carbonFlags: Int {
        var carbonFlags = 0
        if contains(.command) { carbonFlags |= cmdKey }
        if contains(.option) { carbonFlags |= optionKey }
        if contains(.control) { carbonFlags |= controlKey }
        if contains(.shift) { carbonFlags |= shiftKey }
        return carbonFlags
    }
} 