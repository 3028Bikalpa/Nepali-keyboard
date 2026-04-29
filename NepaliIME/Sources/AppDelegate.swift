// filepath: NepaliIME/Sources/AppDelegate.swift
// AppDelegate.swift - Application delegate for Nepali IME
// Handles application lifecycle events

import Cocoa
import InputMethodKit
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Application Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Explicitly register this input source with the Text Input Sources system.
        // This is required on macOS 13+ for the IME to appear in System Settings.
        let bundleURL = Bundle.main.bundleURL as CFURL
        let status = TISRegisterInputSource(bundleURL)
        NSLog("NepaliIME: Launched, TISRegisterInputSource status = \(status)")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Cleanup when the input method is unloaded
        NSLog("NepaliIME: Application terminating")
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}