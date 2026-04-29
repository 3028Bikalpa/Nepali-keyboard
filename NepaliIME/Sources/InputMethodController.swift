// filepath: NepaliIME/Sources/InputMethodController.swift
// InputMethodController.swift - Main input method controller for Nepali IME
// Handles keyboard events, composing buffer, and candidate selection

import Cocoa
import InputMethodKit

/// Main input method controller that handles keyboard events
/// This class is registered in Info.plist via InputMethodServerControllerClass
class InputMethodController: IMKInputController {
    
    // MARK: - Properties
    
    /// The current composing buffer (Latin text being typed)
    private var composingBuffer: String = ""
    
    /// Candidate window controller for showing suggestions
    private var candidateWindow: CandidateWindowController?
    
    /// Nepali dictionary for looking up translations
    private let dictionary = NepaliDictionary()
    
    /// Transliteration engine for fallback conversion
    private let transliterationEngine = TransliterationEngine()
    
    /// Current candidates from dictionary lookup
    private var candidates: [String] = []
    
    // MARK: - IMKInputController Overrides
    
    /// Called when the input method is activated
    override func activateServer(_ sender: Any!) {
        super.activateServer(sender)
        NSLog("NepaliIME: Activated")
        clearBuffer()
    }
    
    /// Called when the input method is deactivated
    override func deactivateServer(_ sender: Any!) {
        super.deactivateServer(sender)
        NSLog("NepaliIME: Deactivated")
        commitComposing()
    }
    
    /// Handle keyboard input events
    /// This is the main entry point for all key events
    override func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
        guard let event = event else { return false }
        
        // Only handle key down events
        guard event.type == .keyDown else { return false }
        
        // Get the key code and modifiers
        let keyCode = event.keyCode
        let modifiers = event.modifierFlags
        
        // Check for modifier keys (except shift)
        let hasModifiers = modifiers.contains(.command) || 
                          modifiers.contains(.control) || 
                          modifiers.contains(.option)
        
        if hasModifiers {
            // Pass through command/control/option combinations
            return false
        }
        
        // Handle special keys
        switch keyCode {
        case 36: // Return/Enter
            return handleReturn(sender)
        case 51: // Backspace
            return handleBackspace(sender)
        case 53: // Escape
            return handleEscape(sender)
        case 49: // Space
            return handleSpace(sender)
        case 123: // Left arrow
            return handleArrowLeft(sender)
        case 124: // Right arrow
            return handleArrowRight(sender)
        case 125: // Down arrow
            return handleArrowDown(sender)
        case 126: // Up arrow
            return handleArrowUp(sender)
        default:
            break
        }
        
        // Handle number keys 1-9 for candidate selection
        if let characters = event.characters, !characters.isEmpty {
            let char = characters.lowercased()
            if let num = Int(char), num >= 1 && num <= 9 {
                return handleNumberSelection(num, client: sender)
            }
        }
        
        // Handle regular character input
        if let characters = event.characters, !characters.isEmpty {
            return handleCharacterInput(characters, client: sender)
        }
        
        return false
    }
    
    // MARK: - Input Handling
    
    /// Handle regular character input (a-z)
    private func handleCharacterInput(_ characters: String, client sender: Any!) -> Bool {
        // Only accept ASCII letters
        guard characters.range(of: "^[a-zA-Z]+$", options: .regularExpression) != nil else {
            return false
        }
        
        // Add to composing buffer
        composingBuffer += characters.lowercased()
        
        // Update candidates
        updateCandidates()
        
        // Show the composing text in the client
        updateClientComposition(sender)
        
        // Show candidate window if we have matches
        if !candidates.isEmpty {
            showCandidateWindow(for: sender)
        } else if !composingBuffer.isEmpty {
            // Show transliteration preview
            let preview = transliterationEngine.transliterate(composingBuffer)
            showCandidateWindow(for: sender, withFallback: preview)
        }
        
        return true
    }
    
    /// Handle Return/Enter key - commit first candidate
    private func handleReturn(_ client: Any!) -> Bool {
        if composingBuffer.isEmpty {
            return false
        }
        
        commitFirstCandidate(client)
        return true
    }
    
    /// Handle Space key - commit first candidate or insert space
    private func handleSpace(_ client: Any!) -> Bool {
        if composingBuffer.isEmpty {
            return false
        }
        
        // If we have candidates, commit the first one
        if !candidates.isEmpty {
            commitFirstCandidate(client)
            return true
        }
        
        // Otherwise, commit the transliteration
        commitTransliteration(client)
        return true
    }
    
    /// Handle Backspace key - remove last character
    private func handleBackspace(_ client: Any!) -> Bool {
        if composingBuffer.isEmpty {
            return false
        }
        
        // Remove last character
        composingBuffer.removeLast()
        
        if composingBuffer.isEmpty {
            clearBuffer()
            hideCandidateWindow()
        } else {
            updateCandidates()
            updateClientComposition(client)
            
            if !candidates.isEmpty {
                showCandidateWindow(for: client)
            } else {
                let preview = transliterationEngine.transliterate(composingBuffer)
                showCandidateWindow(for: client, withFallback: preview)
            }
        }
        
        return true
    }
    
    /// Handle Escape key - clear composing buffer
    private func handleEscape(_ client: Any!) -> Bool {
        if composingBuffer.isEmpty {
            return false
        }
        
        clearBuffer()
        hideCandidateWindow()
        return true
    }
    
    /// Handle arrow keys for candidate navigation
    private func handleArrowLeft(_ client: Any!) -> Bool {
        // Could implement candidate selection history
        return false
    }
    
    private func handleArrowRight(_ client: Any!) -> Bool {
        return false
    }
    
    private func handleArrowDown(_ client: Any!) -> Bool {
        // Select next candidate
        return false
    }
    
    private func handleArrowUp(_ client: Any!) -> Bool {
        // Select previous candidate
        return false
    }
    
    /// Handle number key selection (1-9)
    private func handleNumberSelection(_ number: Int, client: Any!) -> Bool {
        let index = number - 1
        
        guard index < candidates.count else {
            return false
        }
        
        commitCandidate(candidates[index], client: client)
        return true
    }
    
    // MARK: - Candidate Management
    
    /// Update candidates based on current composing buffer
    private func updateCandidates() {
        if composingBuffer.isEmpty {
            candidates = []
        } else {
            candidates = dictionary.lookup(word: composingBuffer)
        }
    }
    
    /// Show candidate window with current candidates
    private func showCandidateWindow(for client: Any!, withFallback fallback: String? = nil) {
        if candidateWindow == nil {
            candidateWindow = CandidateWindowController()
        }
        
        var displayCandidates = candidates
        if displayCandidates.isEmpty, let fallback = fallback {
            displayCandidates = [fallback]
        }
        
        candidateWindow?.show(candidates: displayCandidates, at: getClientCursorPosition(client))
    }
    
    /// Hide the candidate window
    private func hideCandidateWindow() {
        candidateWindow?.hide()
    }
    
    // MARK: - Client Communication
    
    /// Update the client's composing text
    private func updateClientComposition(_ client: Any!) {
        guard let imClient = client as? IMKTextInput else { return }
        
        // Create attributed string with the composing text
        let attrs: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let composingString = NSAttributedString(string: composingBuffer, attributes: attrs)
        
        // Set the marked text (composing buffer) in the client
        imClient.setMarkedText(composingString, selectionRange: NSRange(location: composingBuffer.count, length: 0), replacementRange: NSRange(location: NSNotFound, length: 0))
    }
    
    /// Get cursor position from client for candidate window placement
    private func getClientCursorPosition(_ client: Any!) -> NSPoint {
        guard let imClient = client as? IMKTextInput else {
            return NSPoint(x: 100, y: 100)
        }
        
        var rect = NSRect.zero
        imClient.attributes(forCharacterIndex: 0, lineHeightRectangle: &rect)
        
        return rect.origin
    }
    
    // MARK: - Commit Methods
    
    /// Commit the first candidate to the client
    private func commitFirstCandidate(_ client: Any!) {
        if !candidates.isEmpty {
            commitCandidate(candidates[0], client: client)
        } else {
            commitTransliteration(client)
        }
    }
    
    /// Commit a specific candidate
    private func commitCandidate(_ candidate: String, client: Any!) {
        guard let imClient = client as? IMKTextInput else { return }
        
        // Insert the committed text
        imClient.insertText(candidate, replacementRange: NSRange(location: NSNotFound, length: 0))
        
        // Clear the composing buffer
        clearBuffer()
        hideCandidateWindow()
    }
    
    /// Commit the transliterated version
    private func commitTransliteration(_ client: Any!) {
        guard let imClient = client as? IMKTextInput else { return }
        
        let result = transliterationEngine.transliterate(composingBuffer)
        imClient.insertText(result, replacementRange: NSRange(location: NSNotFound, length: 0))
        
        clearBuffer()
        hideCandidateWindow()
    }
    
    /// Commit any composing text and clear buffer
    private func commitComposing() {
        clearBuffer()
        hideCandidateWindow()
    }
    
    /// Clear the composing buffer
    private func clearBuffer() {
        composingBuffer = ""
        candidates = []
    }
    
    // MARK: - Menu
    
    /// Provide a menu for the input method
    override func menu() -> NSMenu! {
        let menu = NSMenu(title: "Nepali IME")
        
        let aboutItem = NSMenuItem(title: "About Nepali IME", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        return menu
    }
    
    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Nepali IME"
        alert.informativeText = "Version 1.0\nA Nepali phonetic input method for macOS"
        alert.runModal()
    }
}