// filepath: NepaliIME/Sources/CandidateWindowController.swift
// CandidateWindowController.swift - Candidate window for displaying suggestions
// Shows Nepali Devanagari candidates and allows selection

import Cocoa
import InputMethodKit

/// CandidateWindowController manages the candidate selection window
/// Displays a list of Nepali Devanagari candidates that the user can choose from
class CandidateWindowController: NSObject {
    
    // MARK: - Properties
    
    /// The window that displays candidates
    private var window: NSWindow?
    
    /// Table view for displaying candidates
    private var tableView: NSTableView?
    
    /// Scroll view containing the table
    private var scrollView: NSScrollView?
    
    /// Current list of candidates
    private var candidates: [String] = []
    
    /// Callback for when a candidate is selected
    var onCandidateSelected: ((Int, String) -> Void)?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupWindow()
    }
    
    // MARK: - Window Setup
    
    /// Create and configure the candidate window
    private func setupWindow() {
        // Create the window
        let windowRect = NSRect(x: 0, y: 0, width: 200, height: 150)
        window = NSWindow(
            contentRect: windowRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        guard let window = window else { return }
        
        // Configure window appearance
        window.backgroundColor = NSColor.white.withAlphaComponent(0.95)
        window.isOpaque = false
        window.level = .floating
        window.hasShadow = true
        window.isMovableByWindowBackground = true
        
        // Create content view
        let contentView = NSView(frame: windowRect)
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor.white.cgColor
        contentView.layer?.cornerRadius = 8
        contentView.layer?.borderWidth = 1
        contentView.layer?.borderColor = NSColor.lightGray.cgColor
        
        // Create scroll view
        scrollView = NSScrollView(frame: NSRect(x: 5, y: 5, width: 190, height: 140))
        scrollView?.hasVerticalScroller = true
        scrollView?.hasHorizontalScroller = false
        scrollView?.autohidesScrollers = true
        scrollView?.borderType = .noBorder
        
        // Create table view
        tableView = NSTableView()
        tableView?.headerView = nil
        tableView?.backgroundColor = .clear
        tableView?.intercellSpacing = NSSize(width: 0, height: 2)
        tableView?.rowHeight = 24
        tableView?.selectionHighlightStyle = .regular
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.doubleAction = #selector(tableViewDoubleClick)
        tableView?.target = self
        
        // Add column to table
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("CandidateColumn"))
        column.width = 180
        tableView?.addTableColumn(column)
        
        // Set scroll view document
        scrollView?.documentView = tableView
        
        // Add scroll view to content view
        if let scrollView = scrollView {
            contentView.addSubview(scrollView)
        }
        
        window.contentView = contentView
    }
    
    // MARK: - Public Methods
    
    /// Show the candidate window with given candidates
    /// - Parameters:
    ///   - candidates: Array of candidate strings (Devanagari)
    ///   - position: Screen position to show the window
    func show(candidates: [String], at position: NSPoint) {
        self.candidates = candidates
        
        guard let window = window, !candidates.isEmpty else { return }
        
        // Update table
        tableView?.reloadData()
        
        // Calculate window size based on number of candidates
        let rowCount = min(candidates.count, 9)
        let windowHeight = CGFloat(rowCount) * 26 + 10
        let windowWidth: CGFloat = 200
        
        // Position window below the cursor
        let windowOrigin = NSPoint(
            x: position.x,
            y: position.y - windowHeight - 5
        )
        
        window.setFrame(NSRect(x: windowOrigin.x, y: windowOrigin.y, width: windowWidth, height: windowHeight), display: true)
        
        // Show window
        window.orderFront(nil)
    }
    
    /// Show with fallback candidate (when no dictionary match)
    func show(candidates: [String], at position: NSPoint, withFallback fallback: String) {
        var displayCandidates = candidates
        if displayCandidates.isEmpty {
            displayCandidates = [fallback]
        }
        show(candidates: displayCandidates, at: position)
    }
    
    /// Hide the candidate window
    func hide() {
        window?.orderOut(nil)
    }
    
    /// Update candidates and refresh display
    func updateCandidates(_ newCandidates: [String]) {
        candidates = newCandidates
        tableView?.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func tableViewDoubleClick() {
        let row = tableView?.clickedRow ?? 0
        if row >= 0 && row < candidates.count {
            onCandidateSelected?(row, candidates[row])
        }
    }
}

// MARK: - NSTableViewDataSource

extension CandidateWindowController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return candidates.count
    }
}

// MARK: - NSTableViewDelegate

extension CandidateWindowController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier("CandidateCell")
        
        var cellView = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
        
        if cellView == nil {
            cellView = NSTableCellView()
            cellView?.identifier = identifier
            
            // Create text field
            let textField = NSTextField(labelWithString: "")
            textField.font = NSFont.systemFont(ofSize: 14)
            textField.textColor = .black
            textField.alignment = .left
            textField.frame = NSRect(x: 30, y: 2, width: 150, height: 20)
            cellView?.addSubview(textField)
            cellView?.textField = textField
            
            // Create index label (1-9)
            let indexLabel = NSTextField(labelWithString: "")
            indexLabel.font = NSFont.systemFont(ofSize: 12)
            indexLabel.textColor = .gray
            indexLabel.alignment = .center
            indexLabel.frame = NSRect(x: 5, y: 2, width: 25, height: 20)
            cellView?.addSubview(indexLabel)
            cellView?.imageView = NSImageView()
        }
        
        // Configure cell
        if row < candidates.count {
            cellView?.textField?.stringValue = candidates[row]
            cellView?.textField?.font = NSFont.systemFont(ofSize: 14)
            
            // Show index number for first 9 candidates
            if row < 9 {
                cellView?.subviews.compactMap { $0 as? NSTextField }.first?.stringValue = "\(row + 1)"
            }
        }
        
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 24
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView?.selectedRow ?? -1
        if row >= 0 && row < candidates.count {
            onCandidateSelected?(row, candidates[row])
        }
    }
}