// filepath: NepaliIME/Sources/main.swift
// main.swift - Application entry point for Nepali IME
// This file initializes the InputMethodKit and starts the input method server

import Cocoa
import InputMethodKit
import Carbon

var server: IMKServer?

autoreleasepool {
    // Register with Text Input Sources so the IME appears in System Settings
    let bundleURL = Bundle.main.bundleURL as CFURL
    let status = TISRegisterInputSource(bundleURL)
    NSLog("NepaliIME: TISRegisterInputSource status = \(status)")

    let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.nepaliime.inputmethod"
    server = IMKServer(name: "NepaliIME_Connection", bundleIdentifier: bundleIdentifier)

    NSApplication.shared.run()
}